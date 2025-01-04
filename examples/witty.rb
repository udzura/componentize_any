witty do
  world do
    export "wasi:cli/run@0.2.0"
  end

  package "wasi:cli@0.2.0" do
    interface "run" do
      define "run", :func, {[] => :result}, counterpart: "component_run"
    end
  end
end
