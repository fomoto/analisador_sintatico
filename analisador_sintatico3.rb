require 'pry'
require 'table_print'

class Simbolo
	attr_reader :cadeia, :nome

  def initialize(nome)
    @nome = nome
    @cadeia = {}
  end
end


class Analisador
  attr_accessor :simbolos, :pilha, :cadeia, :regra, :tabs

  def initialize
    @simbolos = []
    @pilha = []
    @cadeia = []
    @regra = []
    @tabs = []
  end

  def analisar(part,sequence)
    fin = 0
    resp = 0
    while fin != 1
    	sb = ''
      sq = ''
    	if simbolos.any?{|s| sb = s if s.nome == pilha.last }
        if sb.cadeia.any?{|k,v| sq = v if k == part } #Existe part no simbolo?
          @tabs << Tab.new('$'+pilha.join, sequence.join, sb.nome + '->' + sq.join)
          if sq == ['!']
            pilha.pop
            if pilha.empty?
              @tabs << Tab.new('$'+pilha.join, sequence.join, 'Success') 
              resp = 1
            end
          else
            pilha.pop #Remove o ultimo elemento da pilha
            pilha.concat(sq.reverse) #Pilha recebe
          end
          if pilha.last == part
            @tabs << Tab.new('$'+pilha.join, sequence.join, '---')
            pilha.pop
            sequence.shift
            fin = 1
          end
        else
          resp = 1
          p 'Erro'
          @tabs << Tab.new('$'+pilha.join, sequence.join, 'Erro') 
          break
        end
    	else
        resp = 1
    		p 'Erro!'
        break
    	end
    end
    resp
  end
  
end

class Tab
  attr_accessor :pilha,:cadeia,:regra
  def initialize(p,c,r)
    @pilha = p
    @cadeia = c
    @regra = r
  end
end

e = Simbolo.new('E')
t = Simbolo.new('T')
s = Simbolo.new('S')
g = Simbolo.new('G')
f = Simbolo.new('F')

e.cadeia.merge!('id' => ['T','S'])
e.cadeia.merge!('num' => ['T','S'])
e.cadeia.merge!('(' => ['T','S'])

t.cadeia.merge!('id' => ['F','G'])
t.cadeia.merge!('num' => ['F','G'])
t.cadeia.merge!('(' => ['F','G'])

s.cadeia.merge!('+' => ['+','T','S'])
s.cadeia.merge!('-' => ['-','T','S'])
s.cadeia.merge!(')' => ['!'])
s.cadeia.merge!('$' => ['!'])

g.cadeia.merge!('+' => ['!'])
g.cadeia.merge!('-' => ['!'])
g.cadeia.merge!('*' => ['*','F','G'])
g.cadeia.merge!('/' => ['/','F','G'])
g.cadeia.merge!('(' => ['!'])
g.cadeia.merge!(')' => ['!'])
g.cadeia.merge!('$' => ['!'])

f.cadeia.merge!('id' => ['id'])
f.cadeia.merge!('num' => ['num'])
f.cadeia.merge!('(' => ['(','E',')'])

#EXEMPLO
#########################
analisador = Analisador.new
analisador.simbolos = [e,t,s,g,f]
analisador.pilha = ['E']

resp = 0
sequence = ['id','*','num','+','id','$']
sequence = ['id', '+', 'num', 'id','$']
# sequence = ['id','*','$']
while resp != 1
 resp = analisador.analisar(sequence.first,sequence) unless sequence.empty?
 break if resp == 1
end

binding.pry