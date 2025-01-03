const std = @import("std");
const zine = @import("zine");

pub fn build(b: *std.Build) !void {
    zine.website(b, .{
        .title = "Tim Culverhouse",
        .host_url = "https://culver.house",
        .layouts_dir_path = "layouts",
        .content_dir_path = "content",
        .assets_dir_path = "assets",
        .debug = true,
    });

    const deploy_step = b.step("deploy", "Deploy to server");
    const rsync = b.addSystemCommand(&.{
        "rsync",
        "--archive",
        "--verbose",
        "--compress",
        b.install_path,
        "tim@culver.house:/var/www/culver.house/",
    });
    rsync.step.dependOn(b.getInstallStep());
    deploy_step.dependOn(&rsync.step);
}
