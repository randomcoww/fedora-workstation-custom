# fedora-silverblue-custom

#### Update from upstream

```
git submodule foreach git pull origin testing-devel
```

#### Build image

From upstream: https://github.com/coreos/coreos-assembler

```
cosa() {
   env | grep COREOS_ASSEMBLER
   set -x
   podman run --rm -ti --security-opt label=disable --privileged --cap-add CAP_SYS_ADMIN            \
              --uidmap=10000:0:1 --uidmap=0:1:10000 --uidmap 10001:10001:55536                      \
              -v ${PWD}:/srv/ --device /dev/kvm --device /dev/fuse                                  \
              --tmpfs /tmp -v /var/tmp:/var/tmp --name cosa-silverblue                              \
              ${COREOS_ASSEMBLER_CONFIG_GIT:+-v $COREOS_ASSEMBLER_CONFIG_GIT:/srv/src/config/:ro}   \
              ${COREOS_ASSEMBLER_GIT:+-v $COREOS_ASSEMBLER_GIT/src/:/usr/lib/coreos-assembler/:ro}  \
              ${COREOS_ASSEMBLER_CONTAINER_RUNTIME_ARGS}                                            \
              ${COREOS_ASSEMBLER_CONTAINER:-quay.io/coreos-assembler/coreos-assembler:latest} "$@"
   rc=$?; set +x; return $rc
}

cosa init https://github.com/randomcoww/fedora-coreos-custom.git
```

Add ignition file from https://github.com/randomcoww/terraform-infra 
```
curl http://127.0.0.1:8080/ignition?ign=desktop \
   | sudo tee src/config/overlay.d/10custom/usr/lib/dracut/modules.d/40ignition-conf/base.ign
```

Run build
```
cosa clean && cosa fetch && cosa build metal
cosa buildextend-live
```
