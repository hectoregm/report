require 'markaby'

html = Markaby::Builder.new do
  head {  title "Mi página personal"}
  body do
    h1 "Bienvenido a mi página personal"
    b "Mis pasatiempos"
    ul do
      li "Correr"
      li "Leer"
      li "Programación"
    end
  end
end
