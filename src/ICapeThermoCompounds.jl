module ICapeThermoCompounds
    export getconstproplist,gettdependentproplist,getpdependentproplist,getnumcompounds,getcompoundlist
    export getcompoundconstant,getpdependentproperty,gettdependentproperty
    using  PhysicalPropertyCalculator
    import CapeOpen.PropertyPackage
    """
      Returns the list of supported constant Physical Properties.
      #= [retval][out] =# props::Vector{ASCIIString}
    """
    function getconstproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        props = vcat(proppackage.constantstrings, proppackage.constantfloats)
        return props
    end

    """
      Returns the list of supported temperature-dependent Physical Properties.
      #= [retval][out] =# props::Vector{ASCIIString})
    """
    function gettdependentproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        props = proppackage.tempreturedependents
        return props
    end

    """
      Returns the list of supported pressure-dependent properties.
      #= [retval][out] =# props::Vector{ASCIIString})
    """
    function getpdependentproplist(
        proppackage::PropertyPackage)
        props::Vector{ASCIIString}
        props = proppackage.pressuredependents
        return props
    end

    """
      Returns the number of Compounds supported.
      #= [retval][out] =# num::Int32
    """
    function getnumcompounds(
        proppackage::PropertyPackage)
        num::Int32
        num = size(proppackage.propertytable["Compounds"])[1]
        return  num
    end

    """
      Returns the list of all Compounds. This includes the Compound identifiers recognised and extra
      information that can be used to further identify the Compounds.
        #= [retval][out] =# compIds::Vector{ASCIIString} List of Compound identifiers.
        #= [retval][out] =# formulae::Vector{ASCIIString} List of Compound formulae.
        #= [retval][out] =# names::Vector{ASCIIString} List of Compound names.
        #= [retval][out] =# boilTemps::Vector{Float64} List of boiling point temperatures.
        #= [retval][out] =# molwts::Vector{Float64} List of molecular weights.
        #= [retval][out] =# casnos::Vector{ASCIIString}) List of Chemical Abstract Service (CAS) Registry numbers.
    """
    function getcompoundlist(
        proppackage::PropertyPackage)

        compIds::Vector{Float64}
        formulae::Vector{ASCIIString}
        names::Vector{ASCIIString}
        boilTemps::Vector{Float64}
        molwts::Vector{Float64}
        casnos::Vector{ASCIIString}

        compondlist=proppackage.property["Compounds"]
        
        compIds=compondlist[:,1]
        formulae=compondlist[:,3]
        names=compondlist[:,2]
        casnos=compondlist[:,4]
        molwts=compondlist[:,5]
        boilTemps=compondlist[:,6]

        return compIds,formulae,names,boilTemps,molwts,casnos
    end

    """
      Returns the values of constant Physical Properties for the specified Compounds.
      #= [retval][out] =# propvals::Vector{Any}
    """
    function getcompoundconstant(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# compIds::Vector{Float64}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Float64}
        propvals=Vector{Float64}()
        for prop in props
          for compId in compIds
            propvals.push!(calculate(prop,getconstpropdata(proppackage,prop,compId)))
          end
        end
        return propvals
    end

    """
      Returns the values of pressure-dependent Physical Properties for the specified pure Compounds.
      #= [out][in] =# propvals::Vector{Float64}
    """
    function getpdependentproperty(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# pressure::Float64,
        #= [in] =# compIds::Vector{Float64}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Float64}
        propvals=Vector{Float64}()
        return propvals
    end

    """
      Returns the values of temperature-dependent Physical Properties for the specified pure Compounds.
      #= [out][in] =# propvals::Vector{Float64})
    """
    function gettdependentproperty(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# temperature::Float64,
        #= [in] =# compIds::Vector{Float64}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals::Vector{Float64}
        propvals=Vector{Float64}()
        for prop in props
          for compId in compIds
            propvals.push!(calculate(prop,gettemppropdata(proppackage,prop,compId)))
          end
        end
        return propvals
    end

end
