
local mt = {}
mt.__index = mt

function Vec2d( x, y ) 
	return setmetatable({x = x or 0, y = y or x or 0}, mt) 
end 

function mt:__unm()
	return Vec2d(-self.x, -self.y)
end

function mt:__mul(num)
	return Vec2d(self.x * num, self.y * num)
end

function mt:__div(num)
	return Vec2d(self.x / num, self.y / num)
end

function mt:__pow(num)
	return Vec2d(self.x ^ num, self.y ^ num)
end

function mt:__mod(num)
	return Vec2d(self.x % num, self.y % num)
end

function mt:__eq(sec)
	return self.x == sec.x and self.y == sec.y
end

function mt:__le(sec)
	return self.x <= sec.x and self.y <= sec.y
end

function mt:__lt(sec)
	return self.x < sec.x and self.y < sec.y
end

function mt:__add(sec)
	return Vec2d(self.x + sec.x, self.y + sec.y)
end

function mt:__sub(sec)
	return Vec2d(self.x - sec.x, self.y - sec.y)
end

function mt:__tostring()
	local xi, xd = math.modf( self.x )
	local yi, yd = math.modf( self.y )
	reutrn Format('%d.%s %d.%s',xi,tostring((xd+1)*1000000):sub(2,7),yi,tostring((yd+1)*1000000):sub(2,7))
end

function mt:Length()
	return math.sqrt(self.x^2 + self.y^2)
end

function mt:sp()
	return unpack(self)
end

