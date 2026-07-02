use flutter_rust_bridge::frb;
use sysinfo::{Disks, Networks, System};

// ─── 结构体定义 ────────────────────────────────────────────────

/// 系统全局信息
#[frb]
pub struct DeepSystemInfo {
    pub host_name: String,
    pub os_name: String,
    pub os_version: String,
    pub kernel_version: String,
    pub distribution_id: String,
    pub uptime_seconds: u64,
    pub boot_time_unix: u64,
    pub load_average_one: f64,
    pub load_average_five: f64,
    pub load_average_fifteen: f64,
}

/// CPU 整体信息
#[frb]
pub struct CpuInfo {
    pub arch: String,
    pub brand: String,
    pub vendor_id: String,
    pub physical_core_count: Option<usize>,
    pub logical_core_count: usize,
    pub global_frequency_mhz: u64,
    pub global_usage_percent: f64,
    pub cores: Vec<CoreInfo>,
}

/// 单个 CPU 核心的信息
#[frb]
pub struct CoreInfo {
    pub name: String,
    pub frequency_mhz: u64,
    pub usage_percent: f64,
}

/// 内存信息（含交换分区）
#[frb]
pub struct MemoryInfo {
    pub total_bytes: u64,
    pub used_bytes: u64,
    pub free_bytes: u64,
    pub available_bytes: u64,
    pub usage_percent: f64,
    pub swap_total_bytes: u64,
    pub swap_used_bytes: u64,
    pub swap_free_bytes: u64,
}

/// 单个挂载点的磁盘信息
#[frb]
pub struct DiskInfo {
    pub name: String,
    pub mount_point: String,
    pub total_bytes: u64,
    pub available_bytes: u64,
    pub usage_percent: f64,
    pub file_system: String,
    pub disk_type: String,
    pub is_removable: bool,
}

/// 单个网络接口的信息
#[frb]
pub struct NetworkInterfaceInfo {
    pub name: String,
    pub mac_address: String,
    pub ip_addresses: Vec<String>,
    pub total_received_bytes: u64,
    pub total_transmitted_bytes: u64,
}

/// 聚合所有深度设备信息的顶层结构体
#[frb]
pub struct DeepDeviceInfo {
    pub system: DeepSystemInfo,
    pub cpu: CpuInfo,
    pub memory: MemoryInfo,
    pub disks: Vec<DiskInfo>,
    pub network_interfaces: Vec<NetworkInterfaceInfo>,
}

// ─── 函数实现 ─────────────────────────────────────────────────

/// 一键采集全部深度设备信息
pub async fn collect_deep_device_info() -> DeepDeviceInfo {
    let mut system = System::new();
    system.refresh_all();

    let disks = Disks::new_with_refreshed_list();
    let networks = Networks::new_with_refreshed_list();

    DeepDeviceInfo {
        system: collect_system_info_inner(),
        cpu: collect_cpu_info_inner(&system),
        memory: collect_memory_info_inner(&system),
        disks: collect_disks_info_inner(&disks),
        network_interfaces: collect_network_info_inner(&networks),
    }
}

/// 仅采集系统全局信息
pub async fn collect_system_info_deep() -> DeepSystemInfo {
    collect_system_info_inner()
}

/// 仅采集 CPU 信息
pub async fn collect_cpu_info_deep() -> CpuInfo {
    let mut system = System::new();
    system.refresh_cpu_all();
    collect_cpu_info_inner(&system)
}

/// 仅采集内存信息
pub async fn collect_memory_info_deep() -> MemoryInfo {
    let mut system = System::new();
    system.refresh_memory();
    collect_memory_info_inner(&system)
}

/// 仅采集磁盘信息
pub async fn collect_disks_info_deep() -> Vec<DiskInfo> {
    let disks = Disks::new_with_refreshed_list();
    collect_disks_info_inner(&disks)
}

/// 仅采集网络接口信息
pub async fn collect_network_info_deep() -> Vec<NetworkInterfaceInfo> {
    let networks = Networks::new_with_refreshed_list();
    collect_network_info_inner(&networks)
}

// ─── 内部辅助函数 ──────────────────────────────────────────────

fn collect_system_info_inner() -> DeepSystemInfo {
    let load = System::load_average();
    DeepSystemInfo {
        host_name: System::host_name().unwrap_or_else(|| "<unknown>".to_string()),
        os_name: System::name().unwrap_or_else(|| "<unknown>".to_string()),
        os_version: System::os_version().unwrap_or_else(|| "<unknown>".to_string()),
        kernel_version: System::kernel_version().unwrap_or_else(|| "<unknown>".to_string()),
        distribution_id: System::distribution_id(),
        uptime_seconds: System::uptime(),
        boot_time_unix: System::boot_time(),
        load_average_one: load.one,
        load_average_five: load.five,
        load_average_fifteen: load.fifteen,
    }
}

fn collect_cpu_info_inner(system: &System) -> CpuInfo {
    let cpus = system.cpus();
    let global_usage = system.global_cpu_usage();

    CpuInfo {
        arch: System::cpu_arch(),
        brand: cpus.first().map(|c| c.brand().to_string()).unwrap_or_default(),
        vendor_id: cpus
            .first()
            .map(|c| c.vendor_id().to_string())
            .unwrap_or_default(),
        physical_core_count: System::physical_core_count(),
        logical_core_count: cpus.len(),
        global_frequency_mhz: cpus.first().map(|c| c.frequency()).unwrap_or(0),
        global_usage_percent: (global_usage as f64 * 100.0).round() / 100.0,
        cores: cpus
            .iter()
            .map(|c| CoreInfo {
                name: c.name().to_string(),
                frequency_mhz: c.frequency(),
                usage_percent: (c.cpu_usage() as f64 * 100.0).round() / 100.0,
            })
            .collect(),
    }
}

fn collect_memory_info_inner(system: &System) -> MemoryInfo {
    let total = system.total_memory();
    let used = system.used_memory();
    let free = system.free_memory();
    let available = system.available_memory();
    let swap_total = system.total_swap();
    let swap_used = system.used_swap();
    let swap_free = system.free_swap();

    MemoryInfo {
        total_bytes: total,
        used_bytes: used,
        free_bytes: free,
        available_bytes: available,
        usage_percent: if total > 0 {
            ((used as f64 / total as f64) * 100.0 * 100.0).round() / 100.0
        } else {
            0.0
        },
        swap_total_bytes: swap_total,
        swap_used_bytes: swap_used,
        swap_free_bytes: swap_free,
    }
}

fn collect_disks_info_inner(disks: &Disks) -> Vec<DiskInfo> {
    disks
        .list()
        .iter()
        .map(|disk| {
            let total = disk.total_space();
            let available = disk.available_space();

            DiskInfo {
                name: disk.name().to_string_lossy().to_string(),
                mount_point: disk.mount_point().to_string_lossy().to_string(),
                total_bytes: total,
                available_bytes: available,
                usage_percent: if total > 0 {
                    let used = total.saturating_sub(available);
                    ((used as f64 / total as f64) * 100.0 * 100.0).round() / 100.0
                } else {
                    0.0
                },
                file_system: disk.file_system().to_string_lossy().to_string(),
                disk_type: format!("{}", disk.kind()),
                is_removable: disk.is_removable(),
            }
        })
        .collect()
}

fn collect_network_info_inner(networks: &Networks) -> Vec<NetworkInterfaceInfo> {
    networks
        .list()
        .iter()
        .map(|(name, data)| NetworkInterfaceInfo {
            name: name.clone(),
            mac_address: format!("{}", data.mac_address()),
            ip_addresses: data
                .ip_networks()
                .iter()
                .map(|ip| format!("{}/{}", ip.addr, ip.prefix))
                .collect(),
            total_received_bytes: data.total_received(),
            total_transmitted_bytes: data.total_transmitted(),
        })
        .collect()
}
