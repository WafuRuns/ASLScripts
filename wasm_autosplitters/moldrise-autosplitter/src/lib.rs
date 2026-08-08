use asr::{
    future::next_tick,
    settings::Gui,
    signature::Signature,
    timer::{self, TimerState},
    watcher::Watcher,
    Address, Process,
};

asr::async_main!(stable);

#[derive(Gui)]
struct Settings {
    /// TODO
    #[default = true]
    my_setting: bool,
    // TODO: Change these settings.
}

fn get_scene_tree(process: &Process, module_address: Address) -> Option<Address> {
    const SIGNATURE: Signature<30> = Signature::new(
        "48 ?? ?? ?? ?? ?? ?? 48 ?? ?? ?? ?? E8 ?? ?? ?? ?? 48 ?? ?? 48 ?? ?? ?? 5B C3 48 ?? ?? 48",
    );

    // TODO: Experimental, for some reason, get_module_range returns a different size than expected
    let correct_module_size: u64 = 0x515E000;

    let signature_address =
        SIGNATURE.scan_process_range(process, (module_address.value(), correct_module_size))?;

    let rip_offset: i32 = process.read(signature_address + 3).ok()?;
    let instruction_end = signature_address.value().wrapping_add(7);
    let scene_tree_ptr_address = instruction_end.wrapping_add(rip_offset as i64 as u64);

    let scene_tree_val: u64 = process.read(scene_tree_ptr_address).ok()?;

    if scene_tree_val == 0 {
        return None;
    }

    Some(Address::from(scene_tree_val))
}

fn get_root(process: &Process, scene_tree: Address) -> Option<Address> {
    let root_val: u64 = process.read(scene_tree + 0x328).ok()?;

    if root_val == 0 {
        return None;
    }

    Some(Address::from(root_val))
}

fn get_base(process: &Process, root: Address) -> Option<Address> {
    let base: u64 = process.read(root + 0x188).ok()?;

    if base == 0 {
        return None;
    }

    Some(Address::from(base))
}

struct PointerPath {
    shift: u64,
    offsets: &'static [u64],
}

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

struct GameState {
    takover_movement: PointerPath,
    rotation_x: PointerPath,
    rotation_y: PointerPath,
    position_x: PointerPath,
    position_y: PointerPath,
    position_z: PointerPath,
}

const GAME_STATE: GameState = GameState {
    takover_movement: PointerPath {
        shift: 0x18,
        offsets: &[0x60, 0x28, 0x8, 0x20, 0x0, 0x0, 0x30],
    },
    rotation_x: PointerPath {
        shift: 0x20,
        offsets: &[0x60, 0x28, 0xE8, 0x60, 0x28, 0x368],
    },
    rotation_y: PointerPath {
        shift: 0x20,
        offsets: &[0x60, 0x28, 0xE8, 0x60, 0x28, 0x36C],
    },
    position_x: PointerPath {
        shift: 0x20,
        offsets: &[0x60, 0x28, 0xE8, 0x60, 0x28, 0x1D0],
    },
    position_y: PointerPath {
        shift: 0x20,
        offsets: &[0x60, 0x28, 0xE8, 0x60, 0x28, 0x1D4],
    },
    position_z: PointerPath {
        shift: 0x20,
        offsets: &[0x60, 0x28, 0xE8, 0x60, 0x28, 0x1D8],
    },
};

async fn main() {
    // TODO: Settings
    let mut settings = Settings::register();

    loop {
        let process = Process::wait_attach("MOLDRISE.exe").await;
        process
            .until_closes(async {
                let module_address = match process.get_module_range("MOLDRISE.exe") {
                    Ok(range) => range.0,
                    Err(_) => {
                        next_tick().await;
                        return;
                    }
                };
                loop {
                    settings.update();

                    let mut takeover_movement_watcher: Watcher<f64> = Watcher::new();
                    let mut rotation_x_watcher: Watcher<f32> = Watcher::new();
                    let mut rotation_y_watcher: Watcher<f32> = Watcher::new();
                    let mut position_x_watcher: Watcher<f32> = Watcher::new();
                    let mut position_y_watcher: Watcher<f32> = Watcher::new();
                    let mut position_z_watcher: Watcher<f32> = Watcher::new();

                    let base = match get_scene_tree(&process, module_address)
                        .and_then(|scene_tree| get_root(&process, scene_tree))
                        .and_then(|root| get_base(&process, root))
                    {
                        Some(b) => b,
                        None => {
                            next_tick().await;
                            continue;
                        }
                    };

                    loop {
                        let rotation_x_state = rotation_x_watcher
                            .update(GAME_STATE.rotation_x.read::<f32>(&process, base));
                        let rotation_y_state = rotation_y_watcher
                            .update(GAME_STATE.rotation_y.read::<f32>(&process, base));
                        let position_x_state = position_x_watcher
                            .update(GAME_STATE.position_x.read::<f32>(&process, base));
                        let position_y_state = position_y_watcher
                            .update(GAME_STATE.position_y.read::<f32>(&process, base));
                        let position_z_state = position_z_watcher
                            .update(GAME_STATE.position_z.read::<f32>(&process, base));
                        let takeover_movement_state = takeover_movement_watcher
                            .update(GAME_STATE.takover_movement.read::<f64>(&process, base));

                        if timer::state() == TimerState::Running {
                            if let Some(takeover_movement) = takeover_movement_state {
                                if takeover_movement.old == 1.5 && takeover_movement.current == 0.6
                                {
                                    timer::split();
                                }
                            } else {
                                break;
                            }
                        }

                        if timer::state() == TimerState::NotRunning {
                            if let (
                                Some(rotation_x),
                                Some(rotation_y),
                                Some(position_x),
                                Some(position_y),
                                Some(position_z),
                            ) = (
                                rotation_x_state,
                                rotation_y_state,
                                position_x_state,
                                position_y_state,
                                position_z_state,
                            ) {
                                if (rotation_x.old == 0.0 && rotation_x.current != 0.0)
                                    || (rotation_y.old == 2.870473146
                                        && rotation_y.current != 2.870473146)
                                    || (position_x.old == 1.343892694
                                        && position_x.current != 1.343892694)
                                    || (position_y.old == 4.267927647
                                        && position_y.current != 4.267927647)
                                    || (position_z.old == -2.671685219
                                        && position_z.current != -2.671685219)
                                {
                                    timer::start();
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
