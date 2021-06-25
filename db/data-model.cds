namespace com.portal;
using { cuid, managed, sap } from '@sap/cds/common';

entity FiltrosPesquisa {
  key   ID          : Integer;
    empresa         : String(4)  @title : 'Empresa' ;
    cod_operacao    : String(4)  @title : 'Código da Operação' ;
}

entity CentroAreaCliente {
  key ID            : String(4)    @title : 'Centro';
    cd              : String(50)   @title : 'Centro de Distribuição';
    estado          : String(2)    @title : 'Estado';
    areaCliente     : String(20)   @title : 'Área Cliente' @assert.range enum { ![CLARO MOVEL]; ![INFRA NET];};
}

entity MaterialConfig {
KEY ID              : Integer    @title : 'ID' ;
    codigo          : String(15) @title : 'Código';
    tecnologia      : String(60) @title : 'Tecnologia';
    modelo          : String(60) @title : 'Modelo';
    fabricante      : String(60) @title : 'Fabricante';
    partNumber      : String(60) @title : 'Part Number';
}

entity Usuarios {
KEY ID              : Integer    @title : 'ID' ;
    email           : String(50) @title : 'Login';
    fornecedor      : String(10) @title : 'Fornecedor';
    cnpj            : String(20) @title : 'CNPJ do Fornecedor';
}

entity Defeitos     : sap.common.CodeList{
  key ID            : String(100);
}

entity Reparos      : sap.common.CodeList{
  key ID            : String(100);
}
entity OrdemServicos  : cuid, managed {
    sequencial        : Integer;
    numero            : String(16);    
    clienteInterno    : String(30);
    nfSaida           : String(10);
    nfSaidaEmissao    : Date;
    nfSaidaExpedicao  : Date;
    cdOrigem          : String(4);
    ufOrigem          : String(2);  
    dataRecebimento   : Date;
    nfRetorno         : String(9);
    nfRetornoEmissao  : Date;
    nfRetornoExpedicao: Date;
    dataEntregaCD     : Date;
    material          : String(15);
    materialDesc      : String(50);
    materialTipo      : String(60);
    materialTecn      : String(60);
    materialFabr      : String(60);
    materialPart      : String(60);
    equipamento       : String(40);
    serial            : String(40);    
    qtdDiasExpedicao  : Integer;
    qtdDiasTransporte : Integer;
    qtdDiasReparador  : Integer;
    nomeReparadora    : String(50);
    defeito           : Association to Defeitos;
    garantia          : Association to StatusBoolean;
    statusAuditoria   : Association to StatusAuditoria;
    statusReparo      : Association to Reparos;
    valorTotal        : Decimal(10,2);
    observacao        : String(50);
    statusFaturamento : Association to StatusBoolean;
    numeroPedido      : String(10);
    statusOS          : String(20);
    remessa           : String(10);    
virtual url           : String(100);        
    nf                : Association to NotasFiscais;
    historico         : Association to many Historicos on historico.ordemServico = $self;
}

@assert.integrity:false 
entity Historicos   : cuid {
    usuario         : String(80);
    data            : DateTime;
    status          : String(50);
    descricao       : String(100);
    ordemServico    : Association to OrdemServicos;
}

entity NotasFiscais   : cuid {
    clienteInterno    : String(30);
    nfSaida           : String(20);
    nfSaidaEmissao    : Date;
    nfSaidaExpedicao  : Date;
    cdOrigem          : String(4);  
    ufOrigem          : String(2);  
    statusReparo1     : String(50);
    statusOS          : String(20);
    Ordens            : Association to many OrdemServicos    
                        on Ordens.nf = $self;    
}
entity StatusBoolean : sap.common.CodeList {
  key ID : String(3);
}
entity StatusAuditoria : sap.common.CodeList {
  key ID : String(30);
}

