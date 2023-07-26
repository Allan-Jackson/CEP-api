require 'rails_helper'

describe 'Usuario model' do
    
    context 'when everything is alright' do
        it "saves the user to the database" do
            usuario = Usuario.new({nome: 'Usunario Teste', email: 'testenario@email.com', senha: 'C4rr0ç!N8A'})
            expect(usuario.valid?).to be_truthy
            expect(usuario.save).to be_truthy
        end
    end

    context 'when property is required' do
        it "is not valid without 'nome'" do
            usuario = Usuario.new({nome: '', email: 'testenario@email.com', senha: 'C4rr0ç!N8A'})
            expect(usuario.valid?).to be_falsy
        end

        it "is not valid with empty 'nome'" do
            usuario = Usuario.new({email: 'testenario@email.com', senha: 'C4rr0ç!N8A'})
            expect(usuario.valid?).to be_falsy
        end

        it "is not valid without 'email'" do
            usuario = Usuario.new({nome: 'Usunario Teste', senha: 'C4rr0ç!N8A'})
            expect(usuario.valid?).to be_falsy
        end

        it "is not valid with empty 'email'" do
            usuario = Usuario.new({nome: 'Usunario Teste', email: '', senha: 'C4rr0ç!N8A'})
            expect(usuario.valid?).to be_falsy
        end

        it "is not valid without 'senha'" do
            usuario = Usuario.new({nome: 'Usunario Teste', email: 'testenario@email.com'})
            expect(usuario.valid?).to be_falsy
        end

        it "is not valid with empty 'senha'" do
            usuario = Usuario.new({nome: 'Usunario Teste', email: 'testenario@email.com', senha: ''})
            expect(usuario.valid?).to be_falsy
        end

    end

    context 'when property is invalid' do
        it "has not a valid format for 'email'" do
            usuario = Usuario.new({nome: 'Usunario Teste', email: 'testenarioemail.com', senha: 'C4rr0ç!N8A'})
            expect(usuario.valid?).to be_falsy
        end

        it "has not the minimum size for 'senha'" do
            usuario = Usuario.new({nome: 'Usunario Teste', email: 'testenarioemail.com', senha: 'C4rr0'})
            expect(usuario.valid?).to be_falsy
        end

        it "exceed the maximum size for 'senha'" do
            usuario = Usuario.new({nome: 'Usunario Teste', email: 'testenarioemail.com', senha: '4lr0çC4lr0çC4lr0çC4lr0çC$4lr0çC4lr0çC4lr0çC4lr0çC4lr0çC4lr0çC4lr'})
            expect(usuario.valid?).to be_falsy
        end

    end

end