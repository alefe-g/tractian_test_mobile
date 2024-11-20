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

## Instruções para Execução

1. **Clone o Repositório**:
   ```bash
   git clone https://github.com/alefe-g/tractian_test_mobile.git
