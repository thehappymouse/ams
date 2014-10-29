/**撤销催费明细*/
var ArrarsinfoFields = [
    'ID',
    'Segment',
    'CustomerNumber',
    'CustomerName',
    'Address',
    'YearMonth',
    'Money',
    'IsClean', 'IsCut',
    'PressCount', 'CutCount'
];/**
 * Created by Thinkpad on 14-10-17.
 */

/**收费信息 */
var chargesMoneyFields = [
    'ID',
    'YearMonth',
    'Money',
    'IsClean',
    'PressCount',
    'CutCount',
    'CustomerNumber',
    'Time',
    'CustomerName',
    'UserName',
    'LandlordPhone',
    'RenterPhone',
    'IsRent',
    'IsControl',
    'Year',
    'Charge',
    'ChargeDate',
    'Team',
    'ChargeCount',
    'ControlCount',
    'Phone'
];

/**撤销收费基本信息*  */
var arrarsFreeFields = [
    'ID',
    'PressTime',
    'UserName',
    'UserName',
    'PressStyle',
    'Phone',
    'Photo',
    'CutUserName',
    'CutTime',
    'CutStyle',
    'ResetPhone',
    'ResetTime',
    'IsClean',
    'IsCut',
    'CutCount',
    'Money',
    'YearMonth'
];

/**   催费明细*/
var reminderFields = [
    'ID',
    'Segment',
    'SegUser','Balance',
    'CustomerNumber',
    'CustomerName',
    'Address',
    'YearMonth', 'RenterPhone',
    'Money', 'LandlordPhone',
    'IsClean', 'IsCut',
    'PressCount', 'CutCount'
];

/**   班组管理*/
var groupFields = [
    'ID',
    'Name',
    'Type',
    'TypeName'
];

/**   用户管理*/
var userFields = [
    'ID',
    'Name',
    'Pass',
    'Role',
    'RoleName', 
    'CreateTime', 
    'CreateUser', 
    'TeamID'
];

/**  汇总信息**/
var  summaryFields = [
    'ID',
    'ChargeTeam',
    'Team',
    'Year',
    'ChargeCount',
    'Money',
    'Segment',
    'CustomerNumber',
    'CustomerName',
    'Address',
    'YearMonth',
    'Time',
    'UserName',
    'LandlordPhone',
    'IsRent',
    'Name'
];

/**  催费汇总信息**/
var  countFields = [
    'ID',
    'Segment',
    'CutUserName',
    'CustomerNumber',
    'Name',
    'Address',
    'YearMonth',
    'Money',
    'PressTime',
    'PressStyle',
    'IsClean',
    'CutTime',
    'CutStyle',
    'ResetTime',
    'ResetPhone'
];

/**客户分类统计信息**/
var    customerFelds = [
    'ID',
    'Segment',
    'CustomerNumber',
    'CustomerName',
    'ArrearsCount',
    'Address',
    'LandlordPhone',
    'YearMonth',
    'Money',
    'IsControl',
    'IsClean',
    'IsCut',
    'PressCount',
    'CutCount',
    'AllArrearCount',
    'AllArrearCount',
    'IsSpecial',
    'IsRent'
]