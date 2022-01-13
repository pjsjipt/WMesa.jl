module WMesa

using PyCall
using AbstractMover

export WMesaClient
export move, moveX, position, setreference
export rmove, rmoveX, positionX
export setreferenceX, numaxes 
export waituntildone, stopmotion, absposition, abspositionX
export setabsreference, setabsreferenceX

struct WMesaClient <: AbstractMoverDev
    ip::String
    port::Int32
    server::PyObject
end

AbstractMover.numaxes(dev::WMesaClient) = 1
AbstractMover.numaxes(::Type{WMesaClient}) = 1

function WMesaClient(ip="192.168.0.140", port=9596)
    xmlrpc = pyimport("xmlrpc.client")
    server = xmlrpc.ServerProxy("http://$ip:$port")
    WMesaClient(ip, port, server)
end

AbstractMover.move(dev::WMesaClient, deg; a=false, r=false, sync=true) =
    dev.server["move"](deg, a, r, sync)

AbstractMover.rmove(dev::WMesaClient, deg; sync=true) =
    dev.server["move"](deg, false, true, sync)

AbstractMover.moveX(dev::WMesaClient, deg; a=false, r=false, sync=true) =
    dev.server["move"](deg, a, r, sync)

AbstractMover.rmoveX(dev::WMesaClient, deg; sync=true) =
    dev.server["move"](deg, false, true, sync)


AbstractMover.position(dev::WMesaClient) = dev.server["position"]()
AbstractMover.absposition(dev::WMesaClient) = dev.server["abs_position"]()
AbstractMover.positionX(dev::WMesaClient) = dev.server["position"]()
AbstractMover.abspositionX(dev::WMesaClient) = dev.server["abs_position"]()

AbstractMover.setreference(dev::WMesaClient, deg=0) = dev.server["set_reference"](deg)
AbstractMover.setreferenceX(dev::WMesaClient, deg=0) = dev.server["set_reference"](deg)

AbstractMover.setabsreference(dev::WMesaClient) = dev.server["set_abs_reference"]()
AbstractMover.setabsreferenceX(dev::WMesaClient) = dev.server["set_abs_reference"]()

AbstractMover.waituntildone(dev::WMesaClient) = dev.server["waitUntilDone"]()

AbstractMover.stopmotion(dev::WMesaClient) = dev.server["stop"]()


end
