using OrdemService as service from '../../srv/ordem-service';

extend OrdemService.MaterialConfig with @( 
    odata.draft.enabled,
    Capabilities : [ { 
                        DeleteRestrictions : {Deletable : false},
                        SearchRestrictions : {Searchable: false} 
                      } 
                    ],
    Common       : { Label : 'Materiais'} ,
    UI: {
        SelectionFields : [  codigo, tecnologia, modelo, fabricante, partNumber],    
        LineItem: [
            { Value: codigo,                Label: 'Material'},
            { Value: tecnologia,            Label: 'Tecnologia'},
            { Value: modelo,                Label: 'Modelo'},
            { Value: fabricante,            Label: 'Fabricante'},
            { Value: partNumber,            Label: 'Part Number'}                                    
        ],
        HeaderInfo : {
            TypeName       : 'Material',
            TypeNamePlural : 'Materiais',
            TypeImageUrl   : 'sap-icon://document-text',
            Title          : {Label: 'Material', Value : codigo },
            Description    : {Label: 'Modelo', Value : modelo }
        },        
        PresentationVariant : {
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : codigo,
                    Descending : true,
                },
            ],
            Visualizations : ['@UI.LineItem']
        },                         
        Facets: [       
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#MaterialData',
                Label  : 'Material'
            }                
        ],
        FieldGroup #MaterialData : {
            Data : [ 
                { Value: codigo,                Label: 'Material'},
                { Value: tecnologia,            Label: 'Tecnologia'},
                { Value: modelo,                Label: 'Modelo'},
                { Value: fabricante,            Label: 'Fabricante'},
                { Value: partNumber,            Label: 'Part Number'}                    
            ]
        }        
    }        
);

