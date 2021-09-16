SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=false
LATESTARTSERVICE=true

REPLACE="

"

print_modname() {
  ui_print "*******************************"
  ui_print "     MIUI GLOBAL 本地化模块    "
  ui_print "*******************************"
}

on_install() {
  ui_print "- 释放模块文件"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  ui_print "- 释放补充包"
  unzip -o "$ZIPFILE" 'installable/*' -d $MODPATH >&2
  ui_print "- 建立必要的链接"
  ui_print "-- creating Mipay lib symlink..."
  mkdir -p "$MODPATH/system/app/NextPay/lib/arm64"
  ln -s "/system/lib64/libentryexpro.so" "$MODPATH/system/app/NextPay/lib/arm64/libentryexpro.so"
  ln -s "/system/lib64/libuptsmaddonmi.so" "$MODPATH/system/app/NextPay/lib/arm64/libuptsmaddonmi.so"
  mkdir -p "$MODPATH/system/app/TSMClient/lib/arm64"
  ln -s "/system/lib64/libentryexpro.so" "$MODPATH/system/app/TSMClient/lib/arm64/libentryexpro.so"
  ln -s "/system/lib64/libuptsmaddonmi.so" "$MODPATH/system/app/TSMClient/lib/arm64/libuptsmaddonmi.so"
  ui_print "-- creating XiaoAi VoiceTrigger lib symlink..."
  ln -s "/system/lib64/libmisys_jni.so" "$MODPATH/system/app/VoiceTrigger/lib/arm64/libmisys_jni.so"
  ui_print "-- creating YouDaoEngine lib symlink..."
  mkdir "$MODPATH/system/app/YouDaoEngine/lib/arm64"
  ln -s "/system/lib64/libdict-parser.so" "$MODPATH/system/app/YouDaoEngine/lib/arm64/libdict-parser.so"
  ui_print "- 准备增强模块"
  ui_print "-- 释放增强模块安装包"
  unzip -o "$ZIPFILE" 'riru_modules/*' -d $MODPATH >&2
  ui_print "-- 释放权限修复脚本"
  unzip -o "$ZIPFILE" 'repairPermissions.sh' -d $MODPATH >&2
}

after_intstall() {
  ui_print "- 安装增强模块"
  for file in $MODPATH/riru_modules/*.zip; do
    ui_print "-- installing $file"
    magisk --install-module $file
  done
}

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive  $MODPATH                       0 0 0755 0644
  set_perm            $MODPATH/repairPermissions.sh  0 0 0700

  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

# You can add more functions to assist your custom script code
