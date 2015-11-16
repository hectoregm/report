require 'markaby'

html = Markaby::Builder.new do
  head {  title "Mi pagina personal"}
  body do
    h1 "Bienvenido a mi pagina personal"
    b "Mis pasatiempos"
    ul do
      li "Correr"
      li "Leer"
      li "Programacion"
    end
  end
end
