require 'haml'
require 'haml2erb/attributes_parser'


module Haml2Erb
  class Engine < Haml::Engine
    # Convert HAML → ERB
    def to_erb
      erb_lines = []

      compiler = Haml::Parser.new(@options)
      root = compiler.parse(@haml) # AST

      traverse(root) do |node, indent|
        erb_lines << render_node(node, indent)
      end

      erb_lines.join("\n")
    end

    private

    def traverse(node, indent = 0, &block)
      yield(node, indent)
      node.children.each { |child| traverse(child, indent + 2, &block) }
    end

    def render_node(node, indent)
      prefix = " " * indent
      case node.type
      when :tag
        content = node.value[:value].to_s
        if node.value[:silent]
          "#{prefix}<% #{content} %>"
        elsif node.value[:escape_html] == false || node.value[:preserve]
          "#{prefix}<%= #{content} %>"
        else
          "#{prefix}<%= #{content} %>"
        end
      when :script
        if node.value[:silent]
          "#{prefix}<% #{node.value[:text]} %>"
        else
          "#{prefix}<%= #{node.value[:text]} %>"
        end
      when :text
        "#{prefix}#{node.value[:text]}"
      else
        "#{prefix}<!-- unsupported node type: #{node.type} -->"
      end
    end
  end
end
