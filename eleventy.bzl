load("@build_bazel_rules_nodejs//:providers.bzl", "run_node")

def _elventy_impl(ctx):
    args = ctx.actions.args()
    srcs = ctx.files.srcs

    args.add("--quiet")
    args.add("--input", ctx.attr.input)
    args.add("--output", ctx.outputs.output.path)

    if ctx.file.config:
        srcs = ctx.files.srcs + [ctx.file.config]
        args.add("--config", ctx.file.config.path)

    run_node(
        ctx = ctx,
        inputs = srcs,
        outputs = [ctx.outputs.output],
        arguments = [args],
        tools = depset(ctx.files.data),
        executable = "eleventy",
    )

_eleventy = rule(
    implementation = _elventy_impl,
    attrs = {
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True,
        ),
        "data": attr.label_list(
            mandatory = False,
            default = [],
            allow_files = True,
        ),
        "config": attr.label(
            allow_single_file = True,
        ),
        "input": attr.string(default = "."),
        "output": attr.output(mandatory = True),
        "eleventy": attr.label(
            default = Label("@npm//@11ty/eleventy/bin:eleventy"),
            executable = True,
            cfg = "exec",
        ),
    },
)

def eleventy(name, input = None, output = None, **kwargs):
    if not input:
        input = native.package_name()

    if not output:
        output = name + "_dist"

    _eleventy(
        name = name,
        input = input,
        output = output,
        **kwargs
    )
