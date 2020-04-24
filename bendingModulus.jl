#
#  bendingModulus.jl
#  collagen-model
#
#  Created by Christopher Revell on 30/03/2020.
#
#

__precompile__()
module BendingModulus

using LinearAlgebra
using StaticArrays

function bendingModulus!(pos::MMatrix,v::MMatrix,Nmonomers::Int64,Ndomains::Int64,Ebend::Float64)

    AC = zeros(Float64,3)
    AB = zeros(Float64,3)
    F  = zeros(Float64,3)

    # Loop over all monomers
    @inbounds for ii=1:Nmonomers
        # Loop over all sets of 3 in each monomer chain
        @inbounds for jj=1:Ndomains-2

            AC = pos[(ii-1)*Ndomains+jj+2,:] .- pos[(ii-1)*Ndomains+jj,:]
            AB = pos[(ii-1)*Ndomains+jj+1,:] .- pos[(ii-1)*Ndomains+jj,:]
            F  = Ebend*(AC/2.0 .- AB)

            v[(ii-1)*Ndomains+jj,:]   .-= F/2.0
            v[(ii-1)*Ndomains+jj+1,:] .+= F
            v[(ii-1)*Ndomains+jj+2,:] .-= F/2.0
        end
    end
end

export bendingModulus!

end
