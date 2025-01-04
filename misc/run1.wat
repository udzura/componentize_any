(component
    (core module (;0;)
        (func $_main (;1;) (export "main0") (result i32)
            i32.const 0
            (if (result i32)
                (then i32.const 1)
                (else i32.const 2)
            )
        )
    )
    (core instance $m (instantiate 0))
    (func $main (result (result)) (canon lift (core func $m "main0")))
    (component $C
        (import "main" (func $f (result (result))))
        (export "run" (func $f))
    )
    (instance $c (instantiate $C
        (with "main" (func $main))))
    (export "wasi:cli/run@0.2.0" (instance $c))
)