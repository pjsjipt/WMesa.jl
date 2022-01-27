module WMesa

using PyCall
using AbstractActuators

export WMesaClient, WMesaTest
export move, position, setreference, rmove, numaxes
export waituntildone, stopmotion, absposition, setabsreference

struct WMesaClient <: AbstractRobot
    ip::String
    port::Int32
    server::PyObject
end

AbstractActuators.numaxes(dev::WMesaClient) = 1
AbstractActuators.numaxes(::Type{WMesaClient}) = 1

function WMesaClient(ip="192.168.0.140", port=9596)
    xmlrpc = pyimport("xmlrpc.client")
    server = xmlrpc.ServerProxy("http://$ip:$port")
    WMesaClient(ip, port, server)
end

AbstractActuators.move(dev::WMesaClient, deg; a=false, r=false, sync=true) =
    dev.server["move"](deg, a, r, sync)

AbstractActuators.rmove(dev::WMesaClient, deg; sync=true) =
    dev.server["move"](deg, false, true, sync)


AbstractActuators.position(dev::WMesaClient) = dev.server["position"]()
AbstractActuators.absposition(dev::WMesaClient) = dev.server["abs_position"]()

AbstractActuators.setreference(dev::WMesaClient, deg=0) = dev.server["set_reference"](deg)

AbstractActuators.setabsreference(dev::WMesaClient) = dev.server["set_abs_reference"]()

AbstractActuators.waituntildone(dev::WMesaClient) = dev.server["waitUntilDone"]()

AbstractActuators.stopmotion(dev::WMesaClient) = dev.server["stop"]()


mutable struct WMesaTest <: AbstractRobot
    θ::Float64
    θᵣ::Float64
    Δt::Float64
end

WMesaTest(;dt=1.0) = WMesaTest(0.0, 0.0, dt)

function AbstractActuators.move(dev::WMesaTest, deg; a=false, r=false, sync=true)
    if r
        dev.θ += deg
    elseif a
        dev.θ = deg
    else
        dev.θ = deg + dev.θᵣ
    end

    sync && sleep(dev.Δt)

    p = dev.θ - dev.θᵣ
    println("Movement: θ = $p")
end

AbstractActuators.rmove(dev::WMesaTest, deg; sync=true) = move(dev, deg, r=true, sync=sync)
AbstractActuators.position(dev::WMesaTest) = dev.θ - dev.θᵣ
AbstractActuators.absposition(dev::WMesaTest) = dev.θ

AbstractActuators.setreference(dev::WMesaTest, deg=0) = (dev.θᵣ = dev.θ - deg)
AbstractActuators.setabsreference(dev::WMesaTest) = (dev.θᵣ = 0)


AbstractActuators.waituntildone(dev::WMesaTest) = sleep(dev.Δt)
AbstractActuators.stopmotion(dev::WMesaTest) = sleep(dev.Δt/5)

end


