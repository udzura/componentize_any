(component
    (core module (;0;)
        (func $_main (;1;) (export "add")
            (param $a i32) (param $b i32) (result i32)
            local.get $a
            local.get $b
            i32.add
        )
    )
    (core instance $m (instantiate 0))
    (type $add_t (func (param "a" s32) (param "b" s32) (result s32)))
    (func $intern (type $add_t) (canon lift (core func $m "add")))
    (component $C
        (import "add-intern" (func $f (type $add_t)))
        (export "add" (func $f))
    )
    (instance $c (instantiate $C
        (with "add-intern" (func $intern))))
    (export "c10e:example/adder@0.2.0" (instance $c))
)