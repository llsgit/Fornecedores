using OrdemService as service from '../../srv/ordem-service';

extend OrdemService.Usuarios with @( 
    odata.draft.enabled,
    Capabilities : [ { 
                        DeleteRestrictions : {Deletable : false},
                        SearchRestrictions : {Searchable: false} 
                      } 
                    ],
    Common       : { Label : 'Fornecedor x Usuário'} ,
    UI: {
        SelectionFields : [  email, fornecedor, cnpj ],    
        LineItem: [
            { Value: email,                 Label: 'Login'},
            { Value: fornecedor,            Label: 'Fornecedor'},
            { Value: cnpj,                  Label: 'Cnpj'}                                  
        ],     
        PresentationVariant : {
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : email,
                    Descending : true,
                },
            ],
            Visualizations : ['@UI.LineItem']
        },                         
        Facets: [       
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#MaterialData',
                Label  : 'Fornecedor'
            }                
        ],
        FieldGroup #MaterialData : {
            Data : [ 
                { Value: email,                Label: 'Login'},
                { Value: fornecedor,           Label: 'Fornecedor'},
                { Value: cnpj,                 Label: 'Cnpj'}               
            ]
        }        
    }        
);