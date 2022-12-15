class Element
  attr_accessor :children, :name, :size, :parent, :is_directory
  
  def initialize(name, size, parent, is_directory)
    @children = []
    @name = name
    @size = size
    @parent = parent
    @is_directory = is_directory
  end
  
  def to_s
    name
  end

  def children
    @children
  end

  def get_child(other)
    @children.each { |n|
      if (n.name == other)
        return n
      end
    }
  end

  def add_child(other)
    @children.append(other)
  end

  def set_parent(other)
    @parent = other
  end

  def parent()
    @parent
  end

  def flood()
    if (@is_directory)
      @children.each { |n|
        @size += n.flood()
      }
    end
    @size
  end

  def find_solutions()
    result = 0
    @children.each { |n|
      if n.is_directory
        result += n.find_solutions()
      end
    }
    if @size <= 100000
      result += @size
    end
    return result
  end
end


root = Element.new("", 0, nil, true)
root.set_parent(root)
current = root

File.readlines('input.txt').each do |line|
  arr = line.split

  if (arr[0] == "$")
    if (arr[1] == "cd")
      if (arr[2] == "/")
        current = root
        next
      elsif (arr[2] == "..")
        current = current.parent()
        next
      end
      target = current.get_child(arr[2])
      if (target.instance_of? Element)
        current = target
      else
        new_node = Element.new(arr[2], 0, current, true)
        current.add_child(new_node)
        current = new_node

      end
    end
  elsif (Integer(arr[0], exception: false))
    target = current.get_child(arr[1])
    if not (target.instance_of? Element)
      current.add_child(Element.new(arr[1], Integer(arr[0]), current, false))
    end
  end

end

root.flood()
puts(root.find_solutions().to_s())
