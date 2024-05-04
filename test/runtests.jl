struct RGB8
    r::UInt8
    g::UInt8
    b::UInt8
end
Base.broadcastable(c::RGB8) = Ref(c)

_mapc(f, x::RGB8, y::RGB8) = RGB8(f(x.r, y.r), f(x.g, y.g), f(x.b, y.b))

function lighten(c1::RGB8, c2::RGB8, opacity::AbstractFloat)
    mixed = _mapc(max, c1, c2)
    w(v1, v2) = round(UInt8, v1 * (1 - opacity) + v2 * opacity)
    _mapc(w, c1, mixed)
end

c = RGB8(255, 0, 0)
cs = (RGB8(255, 0, 0), RGB8(0, 255, 0))
f(c1, c2, opacity) = lighten.(c1, c2, opacity)

using InteractiveUtils
versioninfo()

show(Base.JLOptions())

@code_llvm  dump_module=true raw=true  f(c, cs, 0.8)
@code_native f(c, cs, 0.8) # error
