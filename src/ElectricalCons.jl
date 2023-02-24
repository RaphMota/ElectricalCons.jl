module ElectricalCons

struct _Measure
    value::Float64

end

value(m::_Measure) = m.value

struct _Temp
    mean::Float64
    max::Float64
    min::Float64

end

mean(t::_Temp) = t.mean
min(t::_Temp) = t.min
max(t::_Temp) = t.max

struct _WindSpeed
    value::Float64
    maxS::Float64
    maxG::Float64

end

value(w::_WindSpeed) = w.value
maxS(w::_WindSpeed) = w.maxS
maxG(w::_WindSpeed) = w.maxG

struct _Precip
    value::Float64
end
value(p::_Precip) = p.value

struct _Time
    firstpos::Int64
    instant::Int64
    posan::Int64
    measure::_Measure
    wind::_WindSpeed
    temp::_Temp
    precip::_Precip
end

firstpos(t::_Time) = t.firstpos
instant(t::_Time) = t.instant
posan(t::_Time) = t.posan
measure(t::_Time) = t.measure
index(t::_Time) = firstpos(t) + 48 * posan(t) + instant(t)
wind(t::_Time) = t.wind
temp(t::_Time) = t.temp
precip(t::_Time) = t.precip



struct _Campaign
    starttime::_Time
    endtime::_Time
end

starttime(c::_Campaign) = c.starttime
endtime(c::_Campaign) = c.endtime
len(c::_Campaign) = endtime(c) - starttime(c)

using Statistics

function tempday(start::_Time)
    return ([temp(t) for t in start:(start+49)])
end



function consday(start::_Time)
    return ([measure(t) for t in start:(start+49)])
end

function count_nonzero(c::_Campaign)
    n = len(c)
    count = 0
    for t in starttime(c):endtime(c)
        m = measure(t)
        if value(m) == 0
            count += 1
        end
    end
    return (count)
end

function std(c::_Campaign)
    return (Statistics.std(c, mean(c)))
end

using Plots

function plotday(start::_Time)
    time=[t for t in start:(start+49)]
    temp=tempday(start)
    cons=consday(start)
    plot(time, [temp,cons], title="Temperature and consumption during a day", label=["Temperature" "Consumption"], linewidth=3)


end

function plotyear(start::_Time)
    days=[d for d in 1:333]
    tempyear=Vector{Int64}(undef,1,333)
    consyear=Vector{Int64}(undef,1,333)
    for i in 1:333
        time=[i*48+t for t in 1:49]
        temp=sum(tempday(time[1]))/48
        cons=sum(consday(time[1]))/48
    end
    plot(time, [tempyear,consyear], title="Temperature and consumption during a year", label=["Temperature" "Consumption"], linewidth=3)
    
end