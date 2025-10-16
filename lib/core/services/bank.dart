class BankInfo {
  final int id;
  final String name;
  final String code;
  final String shortName;
  final String logo;

  const BankInfo({required this.id, required this.name, required this.code, required this.shortName, required this.logo});
}

class BankService {
  BankService();

  static final List<BankInfo> vietNamBanks = const [
    BankInfo(id: 1, name: 'Ngân hàng TMCP An Bình', code: 'ABB', shortName: 'ABBANK', logo: 'https://cdn.vietqr.io/img/ABB.png'),
    BankInfo(id: 2, name: 'Ngân hàng TMCP Á Châu', code: 'ACB', shortName: 'ACB', logo: 'https://cdn.vietqr.io/img/ACB.png'),
    BankInfo(id: 3, name: 'Ngân hàng TMCP Bắc Á', code: 'BAB', shortName: 'BacABank', logo: 'https://cdn.vietqr.io/img/BAB.png'),
    BankInfo(id: 4, name: 'Ngân hàng TMCP Đầu tư và Phát triển Việt Nam', code: 'BIDV', shortName: 'BIDV', logo: 'https://cdn.vietqr.io/img/BIDV.png'),
    BankInfo(id: 5, name: 'Ngân hàng TMCP Bảo Việt', code: 'BVB', shortName: 'BaoVietBank', logo: 'https://cdn.vietqr.io/img/BVB.png'),
    BankInfo(id: 6, name: 'Ngân hàng TM TNHH MTV Xây dựng Việt Nam', code: 'CBB', shortName: 'CBBank', logo: 'https://cdn.vietqr.io/img/CBB.png'),
    BankInfo(id: 7, name: 'Ngân hàng TNHH MTV CIMB Việt Nam', code: 'CIMB', shortName: 'CIMB', logo: 'https://cdn.vietqr.io/img/CIMB.png'),
    BankInfo(id: 8, name: 'DBS Bank Ltd - Chi nhánh TP. Hồ Chí Minh', code: 'DBS', shortName: 'DBSBank', logo: 'https://cdn.vietqr.io/img/DBS.png'),
    BankInfo(id: 9, name: 'Ngân hàng TNHH MTV Số Vikki', code: 'VIKKI', shortName: 'Vikki', logo: 'https://cdn.vietqr.io/img/Vikki.png'),
    BankInfo(id: 10, name: 'Ngân hàng TMCP Xuất Nhập khẩu Việt Nam', code: 'EIB', shortName: 'Eximbank', logo: 'https://cdn.vietqr.io/img/EIB.png'),
    BankInfo(id: 11, name: 'Ngân hàng TM TNHH MTV Dầu Khí Toàn Cầu', code: 'GPB', shortName: 'GPBank', logo: 'https://cdn.vietqr.io/img/GPB.png'),
    BankInfo(id: 12, name: 'Ngân hàng TMCP Phát triển TP Hồ Chí Minh', code: 'HDB', shortName: 'HDBank', logo: 'https://cdn.vietqr.io/img/HDB.png'),
    BankInfo(id: 13, name: 'Ngân hàng TNHH MTV Hong Leong Việt Nam', code: 'HLBVN', shortName: 'HongLeong', logo: 'https://cdn.vietqr.io/img/HLBVN.png'),
    BankInfo(id: 14, name: 'Ngân hàng TNHH MTV HSBC (Việt Nam)', code: 'HSBC', shortName: 'HSBC', logo: 'https://cdn.vietqr.io/img/HSBC.png'),
    BankInfo(id: 15, name: 'Ngân hàng Công nghiệp Hàn Quốc - Chi nhánh Hà Nội', code: 'IBK-HN', shortName: 'IBKHN', logo: 'https://cdn.vietqr.io/img/IBK.png'),
    BankInfo(id: 16, name: 'Ngân hàng Công nghiệp Hàn Quốc - Chi nhánh TP. HCM', code: 'IBK-HCM', shortName: 'IBKHCM', logo: 'https://cdn.vietqr.io/img/IBK.png'),
    BankInfo(id: 17, name: 'Ngân hàng TMCP Công thương Việt Nam', code: 'ICB', shortName: 'VietinBank', logo: 'https://cdn.vietqr.io/img/ICB.png'),
    BankInfo(id: 18, name: 'Ngân hàng TNHH Indovina', code: 'IVB', shortName: 'IndovinaBank', logo: 'https://cdn.vietqr.io/img/IVB.png'),
    BankInfo(id: 19, name: 'Ngân hàng TMCP Kiên Long', code: 'KLB', shortName: 'KienLongBank', logo: 'https://cdn.vietqr.io/img/KLB.png'),
    BankInfo(id: 20, name: 'Ngân hàng TMCP Bưu điện Liên Việt', code: 'LPB', shortName: 'LPBank', logo: 'https://cdn.vietqr.io/img/LPB.png'),
    BankInfo(id: 21, name: 'Ngân hàng TMCP Quân đội', code: 'MB', shortName: 'MBBank', logo: 'https://cdn.vietqr.io/img/MB.png'),
    BankInfo(id: 22, name: 'Ngân hàng TMCP Hàng Hải Việt Nam', code: 'MSB', shortName: 'MSB', logo: 'https://cdn.vietqr.io/img/MSB.png'),
    BankInfo(id: 23, name: 'Ngân hàng TMCP Nam Á', code: 'NAB', shortName: 'NamABank', logo: 'https://cdn.vietqr.io/img/NAB.png'),
    BankInfo(id: 24, name: 'Ngân hàng TMCP Quốc Dân', code: 'NCB', shortName: 'NCB', logo: 'https://cdn.vietqr.io/img/NCB.png'),
    BankInfo(id: 25, name: 'Ngân hàng Nonghyup - Chi nhánh Hà Nội', code: 'NHB-HN', shortName: 'Nonghyup', logo: 'https://cdn.vietqr.io/img/NHB.png'),
    BankInfo(id: 26, name: 'Ngân hàng TMCP Phương Đông', code: 'OCB', shortName: 'OCB', logo: 'https://cdn.vietqr.io/img/OCB.png'),
    BankInfo(id: 27, name: 'Ngân hàng TNHH MTV Việt Nam Hiện Đại', code: 'MBV', shortName: 'MBV', logo: 'https://cdn.vietqr.io/img/MBV.png'),
    BankInfo(id: 28, name: 'Ngân hàng TNHH MTV Public Việt Nam', code: 'PBVN', shortName: 'PublicBank', logo: 'https://cdn.vietqr.io/img/PBVN.png'),
    BankInfo(id: 29, name: 'Ngân hàng TMCP Xăng dầu Petrolimex', code: 'PGB', shortName: 'PGBank', logo: 'https://cdn.vietqr.io/img/PGB.png'),
    BankInfo(id: 30, name: 'Ngân hàng TMCP Đại Chúng Việt Nam', code: 'PVCB', shortName: 'PVcomBank', logo: 'https://cdn.vietqr.io/img/PVCB.png'),
    BankInfo(id: 31, name: 'Ngân hàng TMCP Sài Gòn', code: 'SCB', shortName: 'SCB', logo: 'https://cdn.vietqr.io/img/SCB.png'),
    BankInfo(id: 32, name: 'Ngân hàng Standard Chartered Việt Nam', code: 'SCVN', shortName: 'StandardChartered', logo: 'https://cdn.vietqr.io/img/SCVN.png'),
    BankInfo(id: 33, name: 'Ngân hàng TMCP Đông Nam Á', code: 'SEAB', shortName: 'SeABank', logo: 'https://cdn.vietqr.io/img/SEAB.png'),
    BankInfo(id: 34, name: 'Ngân hàng TMCP Sài Gòn Công Thương', code: 'SGICB', shortName: 'SaigonBank', logo: 'https://cdn.vietqr.io/img/SGICB.png'),
    BankInfo(id: 35, name: 'Ngân hàng TMCP Sài Gòn - Hà Nội', code: 'SHB', shortName: 'SHB', logo: 'https://cdn.vietqr.io/img/SHB.png'),
    BankInfo(id: 36, name: 'Ngân hàng TMCP Sài Gòn Thương Tín', code: 'STB', shortName: 'Sacombank', logo: 'https://cdn.vietqr.io/img/STB.png'),
    BankInfo(id: 37, name: 'Ngân hàng TNHH MTV Shinhan Việt Nam', code: 'SHBVN', shortName: 'ShinhanBank', logo: 'https://cdn.vietqr.io/img/SHBVN.png'),
    BankInfo(id: 38, name: 'Ngân hàng TMCP Kỹ thương Việt Nam', code: 'TCB', shortName: 'Techcombank', logo: 'https://cdn.vietqr.io/img/TCB.png'),
    BankInfo(id: 39, name: 'Ngân hàng TMCP Tiên Phong', code: 'TPB', shortName: 'TPBank', logo: 'https://cdn.vietqr.io/img/TPB.png'),
    BankInfo(id: 40, name: 'Ngân hàng United Overseas - Chi nhánh TP. Hồ Chí Minh', code: 'UOB', shortName: 'UOB', logo: 'https://cdn.vietqr.io/img/UOB.png'),
    BankInfo(id: 41, name: 'Ngân hàng TMCP Việt Á', code: 'VAB', shortName: 'VietABank', logo: 'https://cdn.vietqr.io/img/VAB.png'),
    BankInfo(id: 42, name: 'Ngân hàng Nông nghiệp và PTNT Việt Nam', code: 'VBA', shortName: 'Agribank', logo: 'https://cdn.vietqr.io/img/VBA.png'),
    BankInfo(id: 43, name: 'Ngân hàng TMCP Ngoại Thương Việt Nam', code: 'VCB', shortName: 'Vietcombank', logo: 'https://cdn.vietqr.io/img/VCB.png'),
    BankInfo(id: 44, name: 'Ngân hàng TMCP Bản Việt', code: 'VCCB', shortName: 'VietCapitalBank', logo: 'https://cdn.vietqr.io/img/VCCB.png'),
    BankInfo(id: 45, name: 'Ngân hàng TMCP Quốc tế Việt Nam', code: 'VIB', shortName: 'VIB', logo: 'https://cdn.vietqr.io/img/VIB.png'),
    BankInfo(id: 46, name: 'Ngân hàng TMCP Việt Nam Thương Tín', code: 'VIETBANK', shortName: 'VietBank', logo: 'https://cdn.vietqr.io/img/VIETBANK.png'),
    BankInfo(id: 47, name: 'Ngân hàng TMCP Việt Nam Thịnh Vượng', code: 'VPB', shortName: 'VPBank', logo: 'https://cdn.vietqr.io/img/VPB.png'),
    BankInfo(id: 48, name: 'Ngân hàng Liên doanh Việt - Nga', code: 'VRB', shortName: 'VRB', logo: 'https://cdn.vietqr.io/img/VRB.png'),
    BankInfo(id: 49, name: 'Ngân hàng TNHH MTV Woori Việt Nam', code: 'WVN', shortName: 'Woori', logo: 'https://cdn.vietqr.io/img/WVN.png'),
    BankInfo(id: 50, name: 'Ngân hàng Kookmin - Chi nhánh Hà Nội', code: 'KBHN', shortName: 'KookminHN', logo: 'https://cdn.vietqr.io/img/KBHN.png'),
    BankInfo(id: 51, name: 'Ngân hàng Kookmin - Chi nhánh TP. Hồ Chí Minh', code: 'KBHCM', shortName: 'KookminHCM', logo: 'https://cdn.vietqr.io/img/KBHCM.png'),
    BankInfo(id: 52, name: 'Ngân hàng Hợp tác xã Việt Nam', code: 'COOPBANK', shortName: 'COOPBANK', logo: 'https://cdn.vietqr.io/img/COOPBANK.png'),
    BankInfo(id: 53, name: 'Ngân hàng số CAKE by VPBank', code: 'CAKE', shortName: 'CAKE', logo: 'https://cdn.vietqr.io/img/CAKE.png'),
    BankInfo(id: 54, name: 'Ngân hàng số Ubank by VPBank', code: 'UBANK', shortName: 'Ubank', logo: 'https://cdn.vietqr.io/img/UBANK.png'),
    BankInfo(id: 55, name: 'Ngân hàng Đại chúng Kasikornbank', code: 'KBANK', shortName: 'KBank', logo: 'https://cdn.vietqr.io/img/KBANK.png'),
    BankInfo(id: 56, name: 'VNPT Money', code: 'VNPTMONEY', shortName: 'VNPTMoney', logo: 'https://cdn.vietqr.io/img/VNPTMONEY.png'),
    BankInfo(id: 57, name: 'Viettel Money', code: 'VTLMONEY', shortName: 'ViettelMoney', logo: 'https://cdn.vietqr.io/img/VIETTELMONEY.png'),
    BankInfo(id: 58, name: 'Ngân hàng số Timo by Ban Viet Bank', code: 'TIMO', shortName: 'Timo', logo: 'https://vietqr.net/portal-service/resources/icons/TIMO.png'),
    BankInfo(id: 59, name: 'Ngân hàng Citibank N.A - Chi nhánh Hà Nội', code: 'CITIBANK', shortName: 'Citibank', logo: 'https://cdn.vietqr.io/img/CITIBANK.png'),
    BankInfo(id: 60, name: 'Ngân hàng KEB Hana - Chi nhánh TP. HCM', code: 'KEBHANAHCM', shortName: 'KEBHanaHCM', logo: 'https://cdn.vietqr.io/img/KEBHANAHCM.png'),
    BankInfo(id: 61, name: 'Ngân hàng KEB Hana - Chi nhánh Hà Nội', code: 'KEBHANAHN', shortName: 'KEBHanaHN', logo: 'https://cdn.vietqr.io/img/KEBHANAHN.png'),
    BankInfo(id: 62, name: 'Công ty Tài chính Mirae Asset (Việt Nam)', code: 'MAFC', shortName: 'MAFC', logo: 'https://cdn.vietqr.io/img/MAFC.png'),
    BankInfo(id: 63, name: 'Ngân hàng Chính sách Xã hội', code: 'VBSP', shortName: 'VBSP', logo: 'https://cdn.vietqr.io/img/VBSP.png'),
    BankInfo(id: 64, name: 'Ngân hàng TMCP Đại Chúng Việt Nam Ngân hàng số', code: 'PVDB', shortName: 'PVcomBank Pay', logo: 'https://cdn.vietqr.io/img/PVCB.png'),
  ];
}
