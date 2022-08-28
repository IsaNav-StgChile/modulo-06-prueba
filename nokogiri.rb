require 'net/http'
require 'json'
require 'nokogiri'

# no olvidar que para que este documento funcione se debe instalar 
# la gema Nokogiri: gem install nokogiri

def request(uri)
    url = URI(uri)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    response = https.request(request)

    JSON.parse(response.read_body)
end

# Realizamos un request a https://jsonplaceholder.typicode.com/photos 
# y obtenemos el arreglo con hashes de fotos.
photos = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=MmQ6N043KwFLnycObTumCLiTgcHCkzSKHmBv5zh8')

# Generamos un arreglo a partir de las fotos del hash.
url_photos = photos.map { |photo| photo['url'] }

# Iteramos el arreglo con las fotos y guardamos sus 
# resultados en un archivo
# * Al momento de guardar agregaremos las etiquetas de HTML
file = File.open('./template.html')
document = Nokogiri::HTML(file)
ul = document.at_css('ul')
ul << "\n"
url_photos.each do |photo|
    ul << "\t\t<li><img src=\"#{photo}\" /></li>\n"
end
ul << "\t"

file.close

new_file = File.open('./index.html', 'w')
new_file.write(document)
new_file.close
