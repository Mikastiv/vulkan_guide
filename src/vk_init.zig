const vk = @import("vulkan-zig");
const c = @import("c.zig");

pub fn pipelineShaderStageCreateInfo(stage: vk.ShaderStageFlags, module: vk.ShaderModule) vk.PipelineShaderStageCreateInfo {
    return .{
        .stage = stage,
        .module = module,
        .p_name = "main",
    };
}

pub fn inputAssemblyCreateInfo(topology: vk.PrimitiveTopology) vk.PipelineInputAssemblyStateCreateInfo {
    return .{
        .topology = topology,
        .primitive_restart_enable = vk.FALSE,
    };
}

pub fn rasterizationStateCreateInfo(
    polygon_mode: vk.PolygonMode,
) vk.PipelineRasterizationStateCreateInfo {
    return .{
        .depth_clamp_enable = vk.FALSE,
        .rasterizer_discard_enable = vk.FALSE,
        .polygon_mode = polygon_mode,
        .line_width = 1,
        .cull_mode = .{},
        .front_face = .clockwise,
        .depth_bias_enable = vk.FALSE,
        .depth_bias_constant_factor = 0,
        .depth_bias_clamp = 0,
        .depth_bias_slope_factor = 0,
    };
}

pub fn multisamplingStateCreateInfo() vk.PipelineMultisampleStateCreateInfo {
    return .{
        .rasterization_samples = .{ .@"1_bit" = true },
        .sample_shading_enable = vk.FALSE,
        .min_sample_shading = 1,
        .alpha_to_coverage_enable = vk.FALSE,
        .alpha_to_one_enable = vk.FALSE,
    };
}

pub fn colorBlendAttachmentState() vk.PipelineColorBlendAttachmentState {
    return .{
        .blend_enable = vk.FALSE,
        .src_color_blend_factor = .one,
        .dst_color_blend_factor = .zero,
        .color_blend_op = .add,
        .src_alpha_blend_factor = .one,
        .dst_alpha_blend_factor = .zero,
        .alpha_blend_op = .add,
        .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = true },
    };
}

pub fn fenceCreateInfo(flags: vk.FenceCreateFlags) vk.FenceCreateInfo {
    return .{
        .flags = flags,
    };
}

pub fn semaphoreCreateInfo(flags: vk.SemaphoreCreateFlags) vk.SemaphoreCreateInfo {
    return .{
        .flags = flags,
    };
}

pub fn imageCreateInfo(format: vk.Format, usage: vk.ImageUsageFlags, extent: vk.Extent3D) vk.ImageCreateInfo {
    return .{
        .image_type = .@"2d",
        .format = format,
        .extent = extent,
        .mip_levels = 1,
        .array_layers = 1,
        .samples = .{ .@"1_bit" = true },
        .tiling = .optimal,
        .usage = usage,
        .sharing_mode = .exclusive,
        .initial_layout = .undefined,
    };
}

pub fn imageViewCreateInfo(format: vk.Format, image: vk.Image, aspect_flags: vk.ImageAspectFlags) vk.ImageViewCreateInfo {
    return .{
        .view_type = .@"2d",
        .image = image,
        .format = format,
        .subresource_range = .{
            .aspect_mask = aspect_flags,
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1,
        },
        .components = .{ .r = .identity, .g = .identity, .b = .identity, .a = .identity },
    };
}

pub fn depthStencilCreateInfo(depth_test: bool, depth_write: bool, compare_op: vk.CompareOp) vk.PipelineDepthStencilStateCreateInfo {
    return .{
        .depth_test_enable = if (depth_test) vk.TRUE else vk.FALSE,
        .depth_write_enable = if (depth_write) vk.TRUE else vk.FALSE,
        .depth_compare_op = if (depth_test) compare_op else .always,
        .depth_bounds_test_enable = vk.FALSE,
        .min_depth_bounds = 0,
        .max_depth_bounds = 1,
        .stencil_test_enable = vk.FALSE,
        .front = .{
            .fail_op = .keep,
            .pass_op = .keep,
            .depth_fail_op = .keep,
            .compare_op = .equal,
            .compare_mask = 0,
            .write_mask = 0,
            .reference = 0,
        },
        .back = .{
            .fail_op = .keep,
            .pass_op = .keep,
            .depth_fail_op = .keep,
            .compare_op = .equal,
            .compare_mask = 0,
            .write_mask = 0,
            .reference = 0,
        },
    };
}

pub fn commandPoolCreateInfo(flags: vk.CommandPoolCreateFlags, queue_family_index: u32) vk.CommandPoolCreateInfo {
    return .{
        .flags = flags,
        .queue_family_index = queue_family_index,
    };
}

pub fn commandBufferAllocateInfo(command_pool: vk.CommandPool) vk.CommandBufferAllocateInfo {
    return .{
        .command_pool = command_pool,
        .command_buffer_count = 1,
        .level = .primary,
    };
}

pub fn vmaAllocatorCreateInfo(instance: vk.Instance, physical_device: vk.PhysicalDevice, device: vk.Device) c.VmaAllocatorCreateInfo {
    return .{
        .instance = c.vulkanZigHandleToC(c.VkInstance, instance),
        .physicalDevice = c.vulkanZigHandleToC(c.VkPhysicalDevice, physical_device),
        .device = c.vulkanZigHandleToC(c.VkDevice, device),
    };
}
