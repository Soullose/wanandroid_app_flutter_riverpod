use flutter_rust_bridge::frb;
use sysinfo::{Networks, System};

#[frb(sync)]
pub fn cpu_arch() -> String {
    println!(
        "System name:              {}\n\
                 System kernel version:    {}\n\
                 System OS version:        {}\n\
                 System OS (long) version: {}\n\
                 System host name:         {}\n\
                 System kernel:            {}",
        System::name().unwrap_or_else(|| "<unknown>".to_owned()),
        System::kernel_version().unwrap_or_else(|| "<unknown>".to_owned()),
        System::os_version().unwrap_or_else(|| "<unknown>".to_owned()),
        System::long_os_version().unwrap_or_else(|| "<unknown>".to_owned()),
        System::host_name().unwrap_or_else(|| "<unknown>".to_owned()),
        System::kernel_long_version(),
    );
    System::cpu_arch()
}
#[frb(sync)]
pub fn system_name() -> String {
    System::name().unwrap_or_else(|| "<unknown>".to_owned())
}

#[frb(sync)]
pub fn long_os_version() -> String {
    System::long_os_version().unwrap_or_else(|| "<unknown>".to_owned())
}
