describe Bezel::Client do
  # Contexto de la prueba, teniendo el API versión 2 del servidor C3.
  context "v2" do

    # Nombre de la prueba
    it "escapes unicode sequences" do
      body = Bezel.client.send(:generate_body,{"value"=>"Déconnexion"})

      # Aserciones sobre el comportamiento esperado.
      body.should_not include('é')
      body.should include('\u00e9')
    end
  end
end
