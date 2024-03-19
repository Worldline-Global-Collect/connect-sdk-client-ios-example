//
//  WCViewType.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#ifndef WCDemo_WCViewType_h
#define WCDemo_WCViewType_h

typedef enum {
    // Switches
    WCSwitchType,
    
    // PickerViews
    WCPickerViewType,
    
    // TextFields
    WCTextFieldType,
    WCIntegerTextFieldType,
    WCFractionalTextFieldType,
    
    // Labels
    WCLabelType,

    // TableViewCells
    WCPaymentProductTableViewCellType,
    WCTextFieldTableViewCellType,
    WCCurrencyTableViewCellType,
    WCErrorMessageTableViewCellType,
    WCSwitchTableViewCellType,
    WCPickerViewTableViewCellType,
    WCButtonTableViewCellType,
    WCLabelTableViewCellType,
    WCTooltipTableViewCellType,
    WCCoBrandsSelectionTableViewCellType,
    WCCoBrandsExplanationTableViewCellType,

    // TableHeaderView
    WCSummaryTableHeaderViewType,
    
    //TableFooterView
    WCButtonsTableFooterViewType
} WCViewType;

#endif
