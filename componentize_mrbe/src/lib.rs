extern crate mrubyedge;

wit_bindgen::generate!({
    world: "root",
    generate_all
});

use exports::wasi::cli::run::Guest;
use mrubyedge::yamrb::helpers::mrb_funcall;
struct TheRoot;

const CODE: &[u8] = include_bytes!("mrblib/run.mrb");

impl Guest for TheRoot {
  fn run() -> Result<(),()> {
    let mut rite = mrubyedge::rite::load(CODE).unwrap();
    let mut vm = mrubyedge::yamrb::vm::VM::open(&mut rite);
    let args = vec![];
    vm.run().unwrap();

    let result = mrb_funcall(&mut vm, None, "run", &args).unwrap();
    match result.value {
        mrubyedge::yamrb::value::RValue::Integer(v) => {
            if v == 0 {
                Ok(())
            } else {
                Err(())
            }
        },
        _ => {
            Err(())
        }
    }
  }
}

export!(TheRoot);