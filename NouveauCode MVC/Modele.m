classdef Modele < handle    
    properties (SetObservable)
        image
        chemin_donnees
    end
    
    properties
        volumes
    end
        
    methods
        function soi = Modele()
%             obj.reset();
        end
        
        function creer_volumes_mat(soi)
            soi.volumes = Volumes_mat(soi); %The child is now informed of his parent
        end
        
        function creer_volumes_RawData_bin(soi)
            soi.volumes = Volumes_RawData_bin(soi); %The child is now informed of his parent
        end
        
%         function definir_volumes_donnees(soi,donnees)
%             soi.volumes.donnees = donnees;
%         end
                
%         function reset(obj)
%         end
        
%         function setDensity(obj,density)
%             obj.density = density;
%         end
%         
%         function setVolume(obj,volume)
%             obj.volume = volume;
%         end
%         
%         function setUnits(obj,units)
%             obj.units = units;
%         end
%         
%         function calculate(obj)
%             obj.mass = obj.density * obj.volume;
%         end
    end
end
