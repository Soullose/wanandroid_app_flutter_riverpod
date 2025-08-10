use sysinfo::{Networks, System};
use flutter_rust_bridge::frb;

#[frb(sync)]
pub fn cpu_arch() -> String {
    System::cpu_arch()
}