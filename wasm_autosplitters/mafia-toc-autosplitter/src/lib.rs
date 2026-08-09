use asr::{
    future::next_tick,
    settings::Gui,
    timer::{self, TimerState},
    watcher::Watcher,
    Address, Process,
};

asr::async_main!(stable);

#[derive(Gui)]
struct Settings {
    /// TODO: Add settings
    #[default = true]
    my_setting: bool,
}

struct PointerPath {
    shift: u64,
    offsets: &'static [u64],
}

struct GameState {
    is_loading: PointerPath,
    mission: PointerPath,
}

// TODO: Add more versions, currently only supports manifest ID 3121778726057603637
// Signature scans would be ideal, the game's stubborn and crashes debuggers
const GAME_STATE: GameState = GameState {
    is_loading: PointerPath {
        shift: 0xB036DE0,
        offsets: &[0x0, 0x18, 0x48],
    },
    mission: PointerPath {
        shift: 0xB1C93D8,
        offsets: &[0x8, 0x8, 0x290, 0x40, 0x8, 0x48, 0x0],
    },
};

impl PointerPath {
    fn read<T: bytemuck::Pod>(&self, process: &Process, base: Address) -> Option<T> {
        let mut current_address: u64 = process.read(base + self.shift).ok()?;

        if current_address == 0 {
            return None;
        }

        let (last_offset, path) = self.offsets.split_last()?;

        for &offset in path {
            current_address = process.read(Address::from(current_address + offset)).ok()?;
            if current_address == 0 {
                return None;
            }
        }

        process
            .read(Address::from(current_address + last_offset))
            .ok()
    }
}

const MISSIONS: &[&str] = &[
    "Plotline.Main.ch_000_prologue",
    "Plotline.Main.ch_010_vineyard",
    "Plotline.Main.ch_020_palio",
    "Plotline.Main.ch_030_extortion",
    "Plotline.Main.ch_040_ruins",
    "Plotline.Main.ch_050_villa",
    "Plotline.Main.ch_060_townhall",
    "Plotline.Main.ch_070_race",
    "Plotline.Main.ch_080_tannery",
    "Plotline.Main.ch_090_strike",
    "Plotline.Main.ch_100_parade",
    "Plotline.Main.ch_110_tonnara",
    "Plotline.Main.ch_120_opera",
    "Plotline.Main.ch_130_killcaptains",
    "Plotline.Main.ch_140_showdown",
];

async fn main() {
    let mut settings = Settings::register();
    let mut mission_index = 0;

    let mut is_loading_watcher: Watcher<u8> = Watcher::new();

    loop {
        let process = Process::wait_attach("MafiaTheOldCountry.exe").await;
        process
            .until_closes(async {
                loop {
                    settings.update();

                    let module_address = match process.get_module_range("MafiaTheOldCountry.exe") {
                        Ok(range) => range.0,
                        Err(_) => {
                            next_tick().await;
                            return;
                        }
                    };

                    loop {
                        let is_loading_state = is_loading_watcher
                            .update(GAME_STATE.is_loading.read::<u8>(&process, module_address));
                        let mission_state = GAME_STATE
                            .mission
                            .read::<[u16; 100]>(&process, module_address);

                        if let Some(is_loading_value) = is_loading_state {
                            if is_loading_value.current != is_loading_value.old {
                                if is_loading_value.current == 1 {
                                    timer::pause_game_time();
                                } else {
                                    timer::resume_game_time();
                                }
                            }
                        }

                        if let Some(mission_value) = mission_state {
                            let mission = String::from_utf16_lossy(&mission_value);
                            if mission.starts_with(MISSIONS[mission_index]) {
                                timer::split();
                                mission_index += 1;
                            }
                        }

                        if timer::state() == TimerState::NotRunning {
                            mission_index = 0;

                            if let (Some(is_loading_value), Some(mission_value)) =
                                (is_loading_state, mission_state)
                            {
                                if is_loading_value.old == 1 && is_loading_value.current == 1 {
                                    let mission = String::from_utf16_lossy(&mission_value);
                                    if mission.starts_with(MISSIONS[mission_index]) {
                                        timer::start();
                                        mission_index += 1;
                                    }
                                }
                            }
                        }

                        next_tick().await;
                    }
                }
            })
            .await;
    }
}
