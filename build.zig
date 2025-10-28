const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimizie = b.standardOptimizeOption(.{});

    const luaLibCode: std.Build.Module.AddCSourceFilesOptions = .{
        .root = b.path("src"),
        .files = &.{
            "lapi.c",
            "lcode.c", 
            "lctype.c", 
            "ldebug.c", 
            "ldo.c", 
            "ldump.c", 
            "lfunc.c", 
            "lgc.c", 
            "llex.c", 
            "lmem.c", 
            "lobject.c", 
            "lopcodes.c", 
            "lparser.c", 
            "lstate.c", 
            "lstring.c", 
            "ltable.c", 
            "ltm.c", 
            "lundump.c", 
            "lvm.c", 
            "lzio.c", 
            "lauxlib.c", 
            "lbaselib.c", 
            "lcorolib.c", 
            "ldblib.c", 
            "liolib.c", 
            "lmathlib.c", 
            "loadlib.c", 
            "loslib.c", 
            "lstrlib.c", 
            "ltablib.c", 
            "lutf8lib.c", 
            "linit.c",
        },
        .flags = &.{
            "-std=gnu99",
            "-DLUA_COMPAT_5_3"
        }
    };

    const zlua = b.addModule("zlua", .{
        .target = target,
        .optimize = optimizie,
        .link_libc = true,
    });

    zlua.addCSourceFiles(luaLibCode);

    const liblua = b.addLibrary(.{
        .name = "liblua",
        .root_module = zlua,
        .linkage = .static,
        .version = std.SemanticVersion{
            .major = 5,
            .minor = 4,
            .patch = 8
        }
    });

    const lua_mod = b.addModule("lua_exe", .{
        .target = target,
        .optimize = optimizie,
        .link_libc = true,
    });
    lua_mod.addCSourceFile(.{
        .file = b.path("src/lua.c"),
        .flags = &.{
            "-std=gnu99",
            "-DLUA_COMPAT_5_3"
        }
    });
    lua_mod.linkLibrary(liblua);

    const lua = b.addExecutable(.{
        .name = "lua",
        .root_module = lua_mod,
        .version = std.SemanticVersion{
            .major = 5,
            .minor = 4,
            .patch = 8
        },
    });

    b.installArtifact(liblua);
    b.installArtifact(lua);
}
