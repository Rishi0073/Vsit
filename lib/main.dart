import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A1628),
  ));
  runApp(const VSITApp());
}

// ─── COLORS ────────────────────────────────────────────────────────────────
const kNavy    = Color(0xFF0A1628);
const kDeep    = Color(0xFF0D1F3C);
const kCard    = Color(0xFF111E35);
const kGold    = Color(0xFFC8972A);
const kGoldLt  = Color(0xFFF0C455);
const kCream   = Color(0xFFFDF6E3);
const kMuted   = Color(0xFF8A9BB5);
const kBorder  = Color(0x40C8972A);
const kGreen   = Color(0xFF2ECC71);
const kRed     = Color(0xFFE74C3C);
const kYellow  = Color(0xFFF1C40F);

// ─── MODEL ─────────────────────────────────────────────────────────────────
enum Priority { low, medium, high }
enum CStatus  { open, review, resolved }

class Complaint {
  final String id, name, roll, email, dept, year, phone, category, subject, description;
  final Priority priority;
  final bool anonymous;
  CStatus status;
  final DateTime createdAt;
  Complaint({
    required this.id, required this.name, required this.roll, required this.email,
    required this.dept, required this.year, required this.phone, required this.category,
    required this.subject, required this.description, required this.priority,
    required this.anonymous, required this.status, required this.createdAt,
  });
  String get statusLabel => status == CStatus.open ? 'Open' : status == CStatus.review ? 'In Review' : 'Resolved';
  String get priorityLabel => priority == Priority.low ? 'Low' : priority == Priority.medium ? 'Medium' : 'High';
  Color get statusColor => status == CStatus.open ? kRed : status == CStatus.review ? kYellow : kGreen;
  Color get priorityColor => priority == Priority.low ? kGreen : priority == Priority.medium ? kYellow : kRed;
}

String _genId() => 'VSIT-${(Random().nextInt(900000) + 100000)}';

// ─── APP ───────────────────────────────────────────────────────────────────
class VSITApp extends StatelessWidget {
  const VSITApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'VSIT Complaint Box',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kNavy,
      colorScheme: const ColorScheme.dark(primary: kGold, surface: kCard, onPrimary: kNavy),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kGold, width: 1.5)),
        hintStyle: TextStyle(color: kMuted.withOpacity(0.6), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(),
    ),
    home: const HomeScreen(),
  );
}

// ─── HOME ──────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  final List<Complaint> _complaints = [
    Complaint(id:'VSIT-845001', name:'Rahul Sharma', roll:'2023IT042', email:'rahul@vsit.edu.in', dept:'B.Sc Information Technology', year:'Second Year (SY)', phone:'9876543210', category:'Labs & IT', subject:'Projector not working in Lab 3', description:'The projector in Lab 3 has been malfunctioning for 2 weeks. It seriously affects our practical sessions and performance.', priority:Priority.high, anonymous:false, status:CStatus.open, createdAt:DateTime.now().subtract(const Duration(days:2))),
    Complaint(id:'VSIT-845002', name:'Anonymous', roll:'—', email:'—', dept:'B.Sc Computer Science', year:'Third Year (TY)', phone:'', category:'Faculty', subject:'Attendance issue in DSA subject', description:'Our DSA faculty is marking absent even when students are present. This is affecting percentages unfairly.', priority:Priority.medium, anonymous:true, status:CStatus.review, createdAt:DateTime.now().subtract(const Duration(days:3))),
    Complaint(id:'VSIT-845003', name:'Priya Nair', roll:'2022IT018', email:'priya@vsit.edu.in', dept:'M.Sc IT', year:'Post Graduate', phone:'9123456789', category:'Canteen', subject:'Food quality has dropped significantly', description:'The canteen food quality has declined over the last month. Stale items are being served regularly.', priority:Priority.low, anonymous:false, status:CStatus.resolved, createdAt:DateTime.now().subtract(const Duration(days:5))),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: kNavy,
    body: Column(children: [
      _Header(),
      Expanded(child: IndexedStack(index: _tab, children: [
        StudentScreen(complaints: _complaints, onAdd: () => setState((){})),
        AdminScreen(complaints: _complaints, onUpdate: () => setState((){})),
      ])),
    ]),
    bottomNavigationBar: _BottomNav(tab: _tab, onTap: (i) => setState(() => _tab = i)),
  );
}

// ─── HEADER ────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: kNavy,
    child: SafeArea(bottom: false, child: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [kGold, kGoldLt], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: kGold.withOpacity(0.4), blurRadius: 14, offset: const Offset(0,4))],
            ),
            child: const Center(child: Text('🎓', style: TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('VSIT Complaint Box', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            const Text('VIDYALANKAR SCHOOL OF INFORMATION TECHNOLOGY',
              style: TextStyle(fontSize: 9, color: kGold, letterSpacing: 0.7, fontWeight: FontWeight.w600)),
          ]),
        ]),
      ),
      Container(height: 1, color: kBorder),
    ])),
  );
}

// ─── BOTTOM NAV ────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int tab; final ValueChanged<int> onTap;
  const _BottomNav({required this.tab, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(color: kCard, border: Border(top: BorderSide(color: kBorder))),
    child: SafeArea(top: false, child: SizedBox(height: 62, child: Row(children: [
      _NavItem(icon:'📥', label:'Submit',  index:0, active:tab==0, onTap:()=>onTap(0)),
      _NavItem(icon:'🔐', label:'Admin',   index:1, active:tab==1, onTap:()=>onTap(1)),
    ]))),
  );
}

class _NavItem extends StatelessWidget {
  final String icon, label; final int index; final bool active; final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.index, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap, behavior: HitTestBehavior.opaque,
      child: Center(child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? kGold.withOpacity(0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(icon, style: const TextStyle(fontSize: 17)),
          if (active) ...[
            const SizedBox(width: 7),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGoldLt)),
          ] else ...[
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12, color: kMuted)),
          ],
        ]),
      )),
    ),
  );
}

// ─── STUDENT SCREEN ────────────────────────────────────────────────────────
class StudentScreen extends StatefulWidget {
  final List<Complaint> complaints; final VoidCallback onAdd;
  const StudentScreen({super.key, required this.complaints, required this.onAdd});
  @override State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _rollC = TextEditingController(),
        _emailC = TextEditingController(), _phoneC = TextEditingController(),
        _subjectC = TextEditingController(), _descC = TextEditingController();
  String _dept='', _year='', _category='';
  Priority _priority = Priority.medium;
  bool _anon=false, _done=false, _loading=false;
  String _cid='';

  static const _cats = [('📚','Academic'),('👨‍🏫','Faculty'),('🏛','Infrastructure'),
    ('🍽','Canteen'),('📖','Library'),('💻','Labs & IT'),('🚫','Ragging'),('🏠','Hostel'),('📌','Other')];
  static const _depts = ['B.Sc Information Technology','B.Sc Computer Science','B.C.A','M.Sc IT','M.Sc CS','MCA'];
  static const _years = ['First Year (FY)','Second Year (SY)','Third Year (TY)','Post Graduate'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_category.isEmpty) { _snack('⚠️  Please select a category'); return; }
    if (_dept.isEmpty) { _snack('⚠️  Please select a department'); return; }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    final id = _genId();
    widget.complaints.insert(0, Complaint(
      id:id, name:_anon?'Anonymous':_nameC.text.trim(), roll:_anon?'—':_rollC.text.trim(),
      email:_anon?'—':_emailC.text.trim(), dept:_dept, year:_year, phone:_phoneC.text.trim(),
      category:_category, subject:_subjectC.text.trim(), description:_descC.text.trim(),
      priority:_priority, anonymous:_anon, status:CStatus.open, createdAt:DateTime.now(),
    ));
    widget.onAdd();
    setState(() { _loading=false; _done=true; _cid=id; });
  }

  void _reset() {
    for (final c in [_nameC,_rollC,_emailC,_phoneC,_subjectC,_descC]) c.clear();
    setState(() { _dept=''; _year=''; _category=''; _priority=Priority.medium; _anon=false; _done=false; });
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(m), backgroundColor: kCard, behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) => _done ? _success() : _form();

  Widget _success() => Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(
    mainAxisAlignment: MainAxisAlignment.center, children: [
      TweenAnimationBuilder<double>(tween: Tween(begin:0,end:1), duration: const Duration(milliseconds:600),
        curve: Curves.elasticOut, builder: (_,v,child) => Transform.scale(scale:v, child:child),
        child: Container(width:88, height:88,
          decoration: BoxDecoration(shape:BoxShape.circle, color:kGreen.withOpacity(0.12), border:Border.all(color:kGreen,width:2)),
          child: const Center(child: Text('✓', style: TextStyle(fontSize:40, color:kGreen, fontWeight:FontWeight.bold))),
        ),
      ),
      const SizedBox(height:24),
      const Text('Complaint Submitted!', style:TextStyle(fontSize:26, fontWeight:FontWeight.w800, color:Colors.white)),
      const SizedBox(height:8),
      Text('Your concern has been registered securely.', style: TextStyle(color:kMuted, fontSize:14), textAlign:TextAlign.center),
      const SizedBox(height:20),
      GestureDetector(
        onLongPress: () { Clipboard.setData(ClipboardData(text:_cid)); _snack('✅ ID copied!'); },
        child: Container(padding: const EdgeInsets.symmetric(horizontal:24,vertical:12),
          decoration: BoxDecoration(color:kGold.withOpacity(0.13), border:Border.all(color:kGold), borderRadius:BorderRadius.circular(10)),
          child: Text(_cid, style: const TextStyle(color:kGoldLt, fontWeight:FontWeight.w800, letterSpacing:2, fontSize:18)),
        ),
      ),
      const SizedBox(height:8),
      Text('Long-press to copy your ID', style:TextStyle(color:kMuted.withOpacity(0.6), fontSize:11)),
      const SizedBox(height:32),
      _outlineBtn('+ Submit Another Complaint', _reset),
    ],
  )));

  Widget _form() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16,20,16,40),
    child: Form(key:_formKey, child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      _pill('YOUR VOICE MATTERS'),
      const SizedBox(height:16),
      _card(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        const Text('File a Complaint', style:TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:Colors.white)),
        const SizedBox(height:4),
        Text('All submissions are treated with strict confidentiality.', style:TextStyle(color:kMuted, fontSize:13)),
        const SizedBox(height:24),

        _lbl('Student Name', req:true), _tf(_nameC,'Your full name', req:true),
        const SizedBox(height:14),
        Row(children:[
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[_lbl('Roll Number',req:true), _tf(_rollC,'e.g. 2024IT001',req:true)])),
          const SizedBox(width:12),
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[_lbl('Phone'), _tf(_phoneC,'+91 XXXXX...', type:TextInputType.phone)])),
        ]),
        const SizedBox(height:14),
        _lbl('Email ID', req:true), _tf(_emailC,'student@vsit.edu.in', req:true, type:TextInputType.emailAddress,
          validate: (v) => (v!=null&&v.contains('@'))?null:'Enter valid email'),
        const SizedBox(height:14),
        _lbl('Department', req:true),
        _drop(value:_dept.isEmpty?null:_dept, hint:'Select Department', items:_depts, onChanged:(v)=>setState(()=>_dept=v??'')),
        const SizedBox(height:14),
        _lbl('Year'),
        _drop(value:_year.isEmpty?null:_year, hint:'Select Year', items:_years, onChanged:(v)=>setState(()=>_year=v??'')),
        const SizedBox(height:20),

        _lbl('Category', req:true),
        Wrap(spacing:8, runSpacing:8, children:[
          for (final c in _cats) _chip(c.$1, c.$2, _category==c.$2, ()=>setState(()=>_category=c.$2)),
        ]),
        const SizedBox(height:20),

        _lbl('Subject', req:true), _tf(_subjectC,'Brief subject of your complaint', req:true),
        const SizedBox(height:14),
        _lbl('Description', req:true),
        TextFormField(controller:_descC, minLines:4, maxLines:7,
          style: const TextStyle(color:Colors.white, fontSize:14),
          decoration: const InputDecoration(hintText:'Describe the issue in detail — include date, location, relevant details...'),
          validator:(v)=>(v==null||v.trim().isEmpty)?'Required':null),
        const SizedBox(height:20),

        _lbl('Priority'),
        Row(children:[
          _priTile('🟢','Low', kGreen, _priority==Priority.low, ()=>setState(()=>_priority=Priority.low)),
          const SizedBox(width:10),
          _priTile('🟡','Medium', kYellow, _priority==Priority.medium, ()=>setState(()=>_priority=Priority.medium)),
          const SizedBox(width:10),
          _priTile('🔴','High / Urgent', kRed, _priority==Priority.high, ()=>setState(()=>_priority=Priority.high)),
        ]),
        const SizedBox(height:20),

        GestureDetector(
          onTap:()=>setState(()=>_anon=!_anon),
          child:AnimatedContainer(duration:const Duration(milliseconds:200),
            padding: const EdgeInsets.symmetric(horizontal:16,vertical:14),
            decoration:BoxDecoration(
              color:_anon?kGold.withOpacity(0.08):Colors.white.withOpacity(0.04),
              border:Border.all(color:_anon?kGold:kBorder),
              borderRadius:BorderRadius.circular(12),
            ),
            child:Row(children:[
              const Text('🕵️', style:TextStyle(fontSize:20)),
              const SizedBox(width:12),
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                const Text('Submit Anonymously', style:TextStyle(fontSize:14, fontWeight:FontWeight.w600, color:Colors.white)),
                Text('Your personal details will be hidden from authorities', style:TextStyle(fontSize:11, color:kMuted)),
              ])),
              _toggle(_anon),
            ]),
          ),
        ),
        const SizedBox(height:24),
        _goldBtn(_loading?'Submitting...':'📨  Submit Complaint', _loading?null:_submit, loading:_loading),
      ])),
    ])),
  );

  Widget _toggle(bool on) => AnimatedContainer(duration:const Duration(milliseconds:200),
    width:42, height:23,
    decoration:BoxDecoration(color:on?kGold:Colors.white.withOpacity(0.12), borderRadius:BorderRadius.circular(100)),
    child:AnimatedAlign(duration:const Duration(milliseconds:200),
      alignment:on?Alignment.centerRight:Alignment.centerLeft,
      child:Container(margin:const EdgeInsets.all(3), width:17, height:17,
        decoration:const BoxDecoration(color:Colors.white, shape:BoxShape.circle))),
  );

  Widget _lbl(String t,{bool req=false}) => Padding(padding:const EdgeInsets.only(bottom:6), child:
    Row(children:[
      Text(t.toUpperCase(), style:const TextStyle(fontSize:10, fontWeight:FontWeight.w700, letterSpacing:1.2, color:kMuted)),
      if(req) const Text('  *', style:TextStyle(color:kGold, fontSize:13, fontWeight:FontWeight.bold)),
    ]));

  Widget _tf(TextEditingController c, String hint, {bool req=false, TextInputType type=TextInputType.text, String? Function(String?)? validate}) =>
    TextFormField(controller:c, keyboardType:type,
      style:const TextStyle(color:Colors.white, fontSize:14),
      decoration:InputDecoration(hintText:hint),
      validator:validate??(req?(v)=>(v==null||v.trim().isEmpty)?'Required':null:null));

  Widget _drop({String? value, required String hint, required List<String> items, required ValueChanged<String?> onChanged}) =>
    DropdownButtonFormField<String>(value:value, dropdownColor:kDeep,
      style:const TextStyle(color:Colors.white, fontSize:14),
      decoration:InputDecoration(hintText:hint),
      icon:const Icon(Icons.keyboard_arrow_down, color:kMuted),
      items:items.map((i)=>DropdownMenuItem(value:i, child:Text(i))).toList(),
      onChanged:onChanged);

  Widget _chip(String emoji, String label, bool sel, VoidCallback onTap) =>
    GestureDetector(onTap:onTap, child:AnimatedContainer(duration:const Duration(milliseconds:180),
      padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),
      decoration:BoxDecoration(color:sel?kGold.withOpacity(0.15):Colors.transparent,
        border:Border.all(color:sel?kGold:kBorder, width:1.2), borderRadius:BorderRadius.circular(8)),
      child:Row(mainAxisSize:MainAxisSize.min, children:[
        Text(emoji, style:const TextStyle(fontSize:14)),
        const SizedBox(width:6),
        Text(label, style:TextStyle(fontSize:13, fontWeight:sel?FontWeight.w700:FontWeight.w400, color:sel?kGoldLt:kMuted)),
      ])));

  Widget _priTile(String e, String l, Color c, bool sel, VoidCallback onTap) => Expanded(
    child:GestureDetector(onTap:onTap, child:AnimatedContainer(duration:const Duration(milliseconds:180),
      padding:const EdgeInsets.symmetric(vertical:12),
      decoration:BoxDecoration(color:sel?c.withOpacity(0.14):Colors.transparent,
        border:Border.all(color:sel?c:kBorder, width:1.2), borderRadius:BorderRadius.circular(10)),
      child:Column(children:[
        Text(e, style:const TextStyle(fontSize:18)),
        const SizedBox(height:4),
        Text(l, style:TextStyle(fontSize:11, fontWeight:sel?FontWeight.w700:FontWeight.w400, color:sel?c:kMuted), textAlign:TextAlign.center),
      ]))));

  @override void dispose() { for(final c in [_nameC,_rollC,_emailC,_phoneC,_subjectC,_descC]) c.dispose(); super.dispose(); }
}

// ─── ADMIN SCREEN ──────────────────────────────────────────────────────────
class AdminScreen extends StatefulWidget {
  final List<Complaint> complaints; final VoidCallback onUpdate;
  const AdminScreen({super.key, required this.complaints, required this.onUpdate});
  @override State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _in = false;
  final _uC = TextEditingController(), _pC = TextEditingController();
  CStatus? _filter;
  bool _obscure = true;

  void _login() {
    if (_uC.text=='admin' && _pC.text=='vsit2024') { setState(()=>_in=true); }
    else _snack('❌ Invalid credentials', kRed);
  }
  void _logout() { setState(()=>_in=false); _uC.clear(); _pC.clear(); }
  void _snack(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content:Text(m), backgroundColor:c, behavior:SnackBarBehavior.floating));

  List<Complaint> get _list => _filter==null ? widget.complaints : widget.complaints.where((c)=>c.status==_filter).toList();

  Future<void> _setStatus(Complaint c, CStatus s) async {
    setState(()=>c.status=s); widget.onUpdate();
    _snack('✅ Status → ${c.statusLabel}', kCard);
  }

  Future<void> _delete(Complaint c) async {
    final ok = await showDialog<bool>(context:context, builder:(_)=>AlertDialog(
      backgroundColor:kCard, shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
      title:const Text('Delete Complaint?', style:TextStyle(color:Colors.white, fontSize:17)),
      content:const Text('This cannot be undone.', style:TextStyle(color:kMuted)),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context,false), child:const Text('Cancel',style:TextStyle(color:kMuted))),
        TextButton(onPressed:()=>Navigator.pop(context,true),  child:const Text('Delete', style:TextStyle(color:kRed))),
      ],
    ));
    if(ok==true){ setState(()=>widget.complaints.remove(c)); widget.onUpdate(); }
  }

  @override
  Widget build(BuildContext context) => _in ? _panel() : _loginView();

  Widget _loginView() => Center(child: SingleChildScrollView(padding:const EdgeInsets.all(24), child:
    Center(child: ConstrainedBox(constraints:const BoxConstraints(maxWidth:400), child:
      _card(child:Column(children:[
        const Text('🔐', style:TextStyle(fontSize:44)),
        const SizedBox(height:12),
        const Text('Admin Portal', style:TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:Colors.white)),
        const SizedBox(height:4),
        Text('Sign in to view & manage complaints', style:TextStyle(color:kMuted, fontSize:13)),
        const SizedBox(height:28),
        Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          _adminLbl('Username'),
          TextField(controller:_uC, style:const TextStyle(color:Colors.white), decoration:const InputDecoration(hintText:'admin')),
          const SizedBox(height:14),
          _adminLbl('Password'),
          TextField(controller:_pC, obscureText:_obscure, style:const TextStyle(color:Colors.white),
            onSubmitted:(_)=>_login(),
            decoration:InputDecoration(hintText:'••••••••',
              suffixIcon:IconButton(icon:Icon(_obscure?Icons.visibility_off:Icons.visibility, color:kMuted, size:18),
                onPressed:()=>setState(()=>_obscure=!_obscure)))),
          const SizedBox(height:20),
          _goldBtn('Sign In  →', _login),
          const SizedBox(height:10),
          Center(child:Text('Demo credentials: admin / vsit2024', style:TextStyle(color:kMuted.withOpacity(0.6), fontSize:11))),
        ]),
      ]))
    ))
  ));

  Widget _adminLbl(String t) => Padding(padding:const EdgeInsets.only(bottom:6),
    child:Text(t.toUpperCase(), style:const TextStyle(fontSize:10, fontWeight:FontWeight.w700, letterSpacing:1.2, color:kMuted)));

  Widget _panel() => SingleChildScrollView(
    padding:const EdgeInsets.fromLTRB(16,20,16,40),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Row(children:[
        _pill('ADMIN DASHBOARD'),
        const Spacer(),
        GestureDetector(onTap:_logout, child:Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:8),
          decoration:BoxDecoration(border:Border.all(color:kRed.withOpacity(0.4)), borderRadius:BorderRadius.circular(8)),
          child:const Text('Logout', style:TextStyle(color:kRed, fontSize:13, fontWeight:FontWeight.w600)))),
      ]),
      const SizedBox(height:10),
      const Text('Complaint Management', style:TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:Colors.white)),
      const SizedBox(height:18),
      _stats(),
      const SizedBox(height:16),
      SingleChildScrollView(scrollDirection:Axis.horizontal, child:Row(children:[
        _fChip('All', null),
        const SizedBox(width:8), _fChip('🔴  Open', CStatus.open),
        const SizedBox(width:8), _fChip('🟡  In Review', CStatus.review),
        const SizedBox(width:8), _fChip('🟢  Resolved', CStatus.resolved),
      ])),
      const SizedBox(height:16),
      if(_list.isEmpty) Center(child:Padding(padding:const EdgeInsets.symmetric(vertical:48), child:Column(children:[
        const Text('📭', style:TextStyle(fontSize:40)),
        const SizedBox(height:12),
        Text('No complaints found.', style:TextStyle(color:kMuted, fontSize:14)),
      ])))
      else ..._list.map((c)=>Padding(padding:const EdgeInsets.only(bottom:12), child:_cCard(c))),
    ]),
  );

  Widget _stats() {
    final tot = widget.complaints.length;
    final op  = widget.complaints.where((c)=>c.status==CStatus.open).length;
    final rv  = widget.complaints.where((c)=>c.status==CStatus.review).length;
    final rs  = widget.complaints.where((c)=>c.status==CStatus.resolved).length;
    return Row(children:[
      _sTile('Total','$tot',Colors.white),   const SizedBox(width:10),
      _sTile('Open', '$op',  kRed),          const SizedBox(width:10),
      _sTile('Review','$rv', kYellow),       const SizedBox(width:10),
      _sTile('Resolved','$rs',kGreen),
    ]);
  }

  Widget _sTile(String l, String v, Color c) => Expanded(child:_card(padding:const EdgeInsets.symmetric(horizontal:8,vertical:14),
    child:Column(children:[
      Text(v, style:TextStyle(fontSize:22, fontWeight:FontWeight.w800, color:c)),
      const SizedBox(height:3),
      Text(l, style:const TextStyle(fontSize:10, color:kMuted, letterSpacing:0.7, fontWeight:FontWeight.w600), textAlign:TextAlign.center),
    ])));

  Widget _fChip(String label, CStatus? s) { final a=_filter==s; return GestureDetector(
    onTap:()=>setState(()=>_filter=s), child:AnimatedContainer(duration:const Duration(milliseconds:180),
      padding:const EdgeInsets.symmetric(horizontal:14,vertical:8),
      decoration:BoxDecoration(color:a?kGold.withOpacity(0.15):Colors.transparent,
        border:Border.all(color:a?kGold:kBorder), borderRadius:BorderRadius.circular(8)),
      child:Text(label, style:TextStyle(fontSize:12, color:a?kGoldLt:kMuted, fontWeight:a?FontWeight.w700:FontWeight.w400)))); }

  Widget _cCard(Complaint c) {
    final dt = '${c.createdAt.day.toString().padLeft(2,'0')} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][c.createdAt.month-1]} ${c.createdAt.year}';
    return _card(padding:const EdgeInsets.all(18), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Row(children:[
        Expanded(child:Text('${c.id}  ·  $dt', style:const TextStyle(fontSize:11, color:kGold, letterSpacing:0.8, fontWeight:FontWeight.w600))),
        _badge(c.statusLabel, c.statusColor),
      ]),
      const SizedBox(height:8),
      Text(c.subject, style:const TextStyle(fontSize:15, fontWeight:FontWeight.w700, color:Colors.white)),
      const SizedBox(height:6),
      Text(c.description.length>140?'${c.description.substring(0,140)}…':c.description,
        style:const TextStyle(fontSize:13, color:kMuted, height:1.5)),
      const SizedBox(height:12),
      Wrap(spacing:8, runSpacing:6, children:[
        _meta('👤', c.anonymous?'Anonymous':c.name),
        _meta('🎓', c.dept.isEmpty?'—':c.dept),
        _meta('📂', c.category),
        _meta('⚡', c.priorityLabel, color:c.priorityColor),
      ]),
      const SizedBox(height:12),
      Container(height:1, color:Colors.white.withOpacity(0.06)),
      const SizedBox(height:10),
      Wrap(spacing:8, runSpacing:8, children:[
        if(c.status!=CStatus.review)   _aBtn('🔄 In Review', kYellow, ()=>_setStatus(c,CStatus.review)),
        if(c.status!=CStatus.resolved) _aBtn('✅ Resolve',   kGreen,  ()=>_setStatus(c,CStatus.resolved)),
        _aBtn('🗑 Delete', kRed, ()=>_delete(c)),
      ]),
    ]));
  }

  Widget _meta(String i, String t,{Color? color}) => Container(
    padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),
    decoration:BoxDecoration(color:Colors.white.withOpacity(0.04), borderRadius:BorderRadius.circular(6)),
    child:Row(mainAxisSize:MainAxisSize.min, children:[
      Text(i, style:const TextStyle(fontSize:11)), const SizedBox(width:4),
      Text(t, style:TextStyle(fontSize:11, color:color??kMuted, fontWeight:FontWeight.w500)),
    ]));

  Widget _badge(String l, Color c) => Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
    decoration:BoxDecoration(color:c.withOpacity(0.12), border:Border.all(color:c.withOpacity(0.4)), borderRadius:BorderRadius.circular(100)),
    child:Text(l, style:TextStyle(fontSize:11, fontWeight:FontWeight.w700, color:c, letterSpacing:0.5)));

  Widget _aBtn(String l, Color c, VoidCallback t) => GestureDetector(onTap:t, child:Container(
    padding:const EdgeInsets.symmetric(horizontal:14,vertical:7),
    decoration:BoxDecoration(color:c.withOpacity(0.08), border:Border.all(color:c.withOpacity(0.4)), borderRadius:BorderRadius.circular(8)),
    child:Text(l, style:TextStyle(fontSize:12, color:c, fontWeight:FontWeight.w600))));

  @override void dispose() { _uC.dispose(); _pC.dispose(); super.dispose(); }
}

// ─── SHARED HELPERS ────────────────────────────────────────────────────────
Widget _card({required Widget child, EdgeInsetsGeometry? padding}) => Container(
  decoration:BoxDecoration(color:kCard, borderRadius:BorderRadius.circular(18),
    border:Border.all(color:kBorder),
    boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.3), blurRadius:24, offset:const Offset(0,10))]),
  padding:padding??const EdgeInsets.all(24), child:child);

Widget _goldBtn(String t, VoidCallback? fn, {bool loading=false}) => GestureDetector(
  onTap:loading?null:fn, child:Container(width:double.infinity, padding:const EdgeInsets.symmetric(vertical:15),
    decoration:BoxDecoration(gradient:const LinearGradient(colors:[kGold,kGoldLt]),
      borderRadius:BorderRadius.circular(12),
      boxShadow:[BoxShadow(color:kGold.withOpacity(0.3), blurRadius:16, offset:const Offset(0,6))]),
    child:loading ? const Center(child:SizedBox(width:22,height:22,child:CircularProgressIndicator(strokeWidth:2.5,color:kNavy)))
      : Text(t, textAlign:TextAlign.center, style:const TextStyle(fontSize:15, fontWeight:FontWeight.w800, color:kNavy, letterSpacing:0.8))));

Widget _outlineBtn(String t, VoidCallback fn) => GestureDetector(
  onTap:fn, child:Container(padding:const EdgeInsets.symmetric(horizontal:22,vertical:11),
    decoration:BoxDecoration(border:Border.all(color:kBorder), borderRadius:BorderRadius.circular(10)),
    child:Text(t, style:const TextStyle(fontSize:14, color:kMuted, fontWeight:FontWeight.w500))));

Widget _pill(String t) => Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:6),
  decoration:BoxDecoration(color:kGold.withOpacity(0.12), border:Border.all(color:kBorder), borderRadius:BorderRadius.circular(100)),
  child:Row(mainAxisSize:MainAxisSize.min, children:[
    Container(width:7,height:7,decoration:const BoxDecoration(color:kGold, shape:BoxShape.circle)),
    const SizedBox(width:8),
    Text(t, style:const TextStyle(fontSize:10, fontWeight:FontWeight.w700, letterSpacing:1.2, color:kGoldLt)),
  ]));
