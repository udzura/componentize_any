(component
    (type $T
        (instance (;0;)
            (type (;0;) (func (param "a" s32) (param "b" s32) (result s32)))
            (export (;0;) "add" (func (type 0)))
        )
    )
    (import "c10e:example/adder@0.2.0" (instance (;0;) (type $T)))

    (core module (;0;)
        (type (;0;) (func (param i32) (param i32) (result i32)))
        (import "c10e:example/adder@0.2.0" "add" (func $_add (;0;) (type 0)))

        (func $_main (;1;) (export "main0") (result i32)
            i32.const 500
            i32.const 200
            call $_add
            i32.const 300
            i32.lt_s
            (if (result i32)
                (then i32.const 0)
                (else i32.const 2)
            )
        )
    )
    (alias export 0 "add" (func $toLower))
    (core func $_add (;0;) (canon lower (func $toLower)))

    (core instance $m0 (;0;)
        (export "add" (func $_add))
    )
    (core instance $m (instantiate 0
        (with "c10e:example/adder@0.2.0" (instance $m0))
    ))
    (func $lifted (result (result)) (canon lift (core func $m "main0")))
    (component $C
        (import "main" (func $g (result (result))))
        (export "run" (func $g))
    )

    (instance $c (instantiate $C
        (with "main" (func $lifted))))

    (export "wasi:cli/run@0.2.0" (instance $c))
)