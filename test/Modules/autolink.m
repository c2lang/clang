// RUN: rm -rf %t
// RUN: %clang_cc1 -emit-llvm -o - -fmodule-cache-path %t -fmodules -fmodules-autolink -F %S/Inputs -I %S/Inputs %s | FileCheck %s

@import autolink.sub2;

int f() {
  return autolink_sub2();
}

@import autolink;

int g() {
  return autolink;
}

@import Module.SubFramework;
const char *get_module_subframework() {
  return module_subframework;
}

@import DependsOnModule.SubFramework;
float *get_module_subframework_dep() {
  return sub_framework;
}

@import NoUmbrella;
int use_no_umbrella() {
  return no_umbrella_A;
}

// NOTE: "autolink_sub" is intentionally not linked.

// CHECK: !llvm.module.flags = !{!0, !1, !2, !3, !4}
// CHECK: !4 = metadata !{i32 6, metadata !"Linker Options", metadata ![[AUTOLINK_OPTIONS:[0-9]+]]}
// CHECK: ![[AUTOLINK_OPTIONS]] = metadata !{metadata ![[AUTOLINK_FRAMEWORK:[0-9]+]], metadata ![[AUTOLINK:[0-9]+]], metadata ![[DEPENDSONMODULE:[0-9]+]], metadata ![[MODULE:[0-9]+]], metadata ![[NOUMBRELLA:[0-9]+]]}
// CHECK: ![[AUTOLINK_FRAMEWORK]] = metadata !{metadata !"-framework", metadata !"autolink_framework"}
// CHECK: ![[AUTOLINK]] = metadata !{metadata !"-lautolink"}
// CHECK: ![[DEPENDSONMODULE]] = metadata !{metadata !"-framework", metadata !"DependsOnModule"}
// CHECK: ![[MODULE]] = metadata !{metadata !"-framework", metadata !"Module"}
// CHECK: ![[NOUMBRELLA]] = metadata !{metadata !"-framework", metadata !"NoUmbrella"}
