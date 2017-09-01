require 'json'
require 'csv'

data_hash = JSON.parse(File.read('result_json/test.json'))

hash =[]
data_hash['event'].each{|i|  hash << i['query']['query_text'] }

# node
words = hash.map { |e| e.split(/[[:blank:]]/) }
collused_words = words.flatten
# p words

File.open('node.csv','wb') do |file|
  file << "query_text\n"
  file << collused_words.join("\n")
end

# edge
# sort
sortedws = collused_words.sort.uniq
sortedws.delete_if(&:empty?)

edge = []
# source
sortedws.each{ |sw|
  words.each{ |tw|
    if tw.include?(sw) && !!tw[tw.index(sw)+1] && !tw[tw.index(sw)+1].empty?
      pair = [sw,tw[tw.index(sw)+1]]
      edge << pair
    else
      next
    end
  }
}
# write to file

CSV.open('edge.csv','wb') do |file|
  file << ['Source','Target',]
  edge.each { |ed|
    file << ed
  }

end
