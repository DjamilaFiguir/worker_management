class Worker {

	int _id;
	String _name;
	String _phone;
	//double _amount;

	Worker(this._name,this._phone);

	Worker.withId(this._id, this._name,this._phone);

	int get id => _id;

	String get nameEdit => _name;

	String get phoneEdit => _phone;

//	double get amountEdit => _amount;


	set nameEdit(String newName) {
		if (newName.length <= 255) {
			this._name = newName;
		}
	}
	set phoneEdit(String newPhone) {
		if (newPhone.length <= 255) {
			this._phone = newPhone;
		}
	}

	/*set amountEdit(double newAmount) {
		this._amount = newAmount;
	}*/

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['name'] = _name;
		map['phone'] = _phone;
		//map['amount'] = _amount;

		return map;
	}

	// Extract a Note object from a Map object
	Worker.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._name = map['name'];
		this._phone = map['phone'];
	//	this._amount = map['amount'];
	}
}