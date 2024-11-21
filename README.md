# TRACTIAN Flutter Project

Este projeto foi desenvolvido como parte de um desafio para a **TRACTIAN**. Trata-se de um aplicativo desenvolvido em **Flutter**, com foco em uma arquitetura organizada, seguindo boas práticas de desenvolvimento, e priorizando a funcionalidade **offline first** utilizando SQLite.

## Estrutura de Pastas

A estrutura de pastas foi projetada para ser direta e fácil de entender, organizada da seguinte forma:

- **`api/`**  
  Contém a classe `UseApi`, responsável por todas as chamadas de API necessárias para o aplicativo.

- **`bloc/`**  
  Segue o padrão **BLoC** (Business Logic Component) para gerenciar estados.  
  - Subpastas dividem os conjuntos de BLoC:  
    - **`state`**: Define os estados possíveis.  
    - **`event`**: Define os eventos que podem disparar alterações no estado.  
    - **`bloc`**: Contém a lógica de negócios central.

- **`components/`**  
  Contém widgets personalizados reutilizáveis para todo o projeto.

- **`helpers/`**  
  Inclui classes auxiliares como `DB`, implementada no padrão **Singleton**, para gerenciar a instância do SQLite e garantir o funcionamento **offline first**.

- **`models/`**  
  Modelos de dados para interações com APIs e armazenamento local.

- **`pages/`**  
  Contém as telas/páginas do aplicativo.

- **`repositories/`**  
  Classes responsáveis por salvar e recuperar dados da instância SQLite.

- **`routes/`**  
  Contém a configuração de rotas e nomes de rotas para a navegação no aplicativo.

- **`services/`**  
  Isola lógicas de negócios complexas, como filtros e outras operações avançadas utilizando **Dart**.

- **`styles/`**  
  Centraliza o uso de imagens, ícones e cores para manter consistência no design do aplicativo.


## Funcionalidades

- **Offline First**: O aplicativo funciona sem conexão à internet, armazenando os dados localmente no SQLite.
- **Gerenciamento de Estado**: Implementado com o padrão BLoC e suporte do Provider.
- **Filtro**: Lógica de filtragem otimizada para manipular dados conforme as regras de negócio.

## Instruções Adicionais

1. **Clone o Repositório**:
   ```bash
   git clone https://github.com/alefe-g/tractian_test_mobile.git
2. **Assista ao Vídeo**:
  ```bash
  https://drive.google.com/file/d1xwmTnP7NBXEz63VqxUvZ7NQEejJCMm00/view?usp=drivesdk

3. **Melhorias Futuras**

Algumas melhorias que poderiam ser implementadas no projeto incluem:

- **Aprimoramento dos Métodos de Pesquisa**: Refatorar os métodos de pesquisa para torná-los mais rápidos e eficientes, garantindo uma melhor experiência ao usuário.  
- **Melhorias na UI e na Árvore de Widgets**: Trabalhar mais profundamente na camada de interface do usuário, especialmente na organização da árvore de widgets, para torná-la mais limpa, reutilizável e performática.  
- **Otimização de Consultas no SQLite**: Refatorar e otimizar as consultas realizadas no SQLite, explorando ao máximo suas funcionalidades para melhorar o desempenho.  
- **Refinamento na Estrutura de Pastas**: Revisitar e reorganizar a estrutura de pastas, buscando uma maior modularidade e melhor separação de responsabilidades.  
- **Cobertura de Testes**: Aumentar a cobertura de testes, implementando testes unitários e de integração para garantir a qualidade do código e a consistência das funcionalidades.  
- **Documentação**: Ampliar e detalhar a documentação do projeto, incluindo instruções para desenvolvedores e diagramas para facilitar a compreensão da arquitetura.  
- **Internacionalização (i18n)**: Adicionar suporte a múltiplos idiomas para alcançar um público mais amplo.  
- **Aprimoramento da Experiência Offline**: Investir em mecanismos para sincronização automática de dados assim que a conexão com a internet for restabelecida.
