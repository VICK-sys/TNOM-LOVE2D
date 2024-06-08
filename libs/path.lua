local path = {}

path.image = function(key)
    return "assets/images/"..key..'.png'
end

path.xml = function(key)
    return "assets/images/"..key..'.xml'
end

return path
