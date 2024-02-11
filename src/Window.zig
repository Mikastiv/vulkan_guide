const std = @import("std");
const c = @import("c.zig");
const vk = @import("vulkan-zig");

const log = std.log.scoped(.glfw);

width: u32,
height: u32,
name: []const u8,
handle: *c.GLFWwindow,
framebuffer_resized: bool = false,
minimized: bool = false,

pub fn init(allocator: std.mem.Allocator, width: u32, height: u32, name: []const u8) !*@This() {
    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);
    c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_TRUE);
    const handle = c.glfwCreateWindow(
        @intCast(width),
        @intCast(height),
        name.ptr,
        null,
        null,
    ) orelse return error.WindowCreationFailed;

    const self = try allocator.create(@This());
    errdefer allocator.destroy(self);

    self.* = .{
        .width = width,
        .height = height,
        .name = name,
        .handle = handle,
    };

    c.glfwSetWindowUserPointer(handle, self);
    _ = c.glfwSetFramebufferSizeCallback(handle, framebufferResizeCallback);
    _ = c.glfwSetWindowIconifyCallback(handle, minimizedCallback);

    return self;
}

pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
    c.glfwDestroyWindow(self.handle);
    allocator.destroy(self);
}

pub fn shouldClose(self: *const @This()) bool {
    return c.glfwWindowShouldClose(self.handle) == c.GLFW_TRUE;
}

pub fn createSurface(self: *const @This(), instance: vk.Instance) !vk.SurfaceKHR {
    var surface: vk.SurfaceKHR = .null_handle;
    const result = c.glfwCreateWindowSurface(instance, self.handle, null, &surface);
    if (result != .success) return error.WindowSurfaceCreationFailed;
    return surface;
}

pub fn extent(self: *const @This()) vk.Extent2D {
    return .{
        .width = self.width,
        .height = self.height,
    };
}

pub const Size = struct {
    width: u32,
    height: u32,
};

pub fn framebufferSize(self: *const @This()) Size {
    var width: i32 = 0;
    var height: i32 = 0;
    c.glfwGetFramebufferSize(self.handle, &width, &height);

    return .{
        .width = width,
        .height = height,
    };
}

fn framebufferResizeCallback(window: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    const self = getUserPointer(window) orelse return;
    self.framebuffer_resized = true;
    self.width = @intCast(width);
    self.height = @intCast(height);
}

fn minimizedCallback(window: ?*c.GLFWwindow, minimized: c_int) callconv(.C) void {
    const self = getUserPointer(window) orelse return;
    self.minimized = if (minimized != 0) true else false;
}

fn getUserPointer(window: ?*c.GLFWwindow) ?*@This() {
    const ptr = c.glfwGetWindowUserPointer(window) orelse {
        log.err("window user pointer is null", .{});
        return null;
    };

    return @ptrCast(@alignCast(ptr));
}
