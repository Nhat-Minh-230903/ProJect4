import pyodbc
import flask
from flask import Flask ,render_template, jsonify, request 
from Config import conn_str

try : 
    conn = pyodbc.connect(conn_str)
    print("oke")
    app = flask.Flask(__name__)

    @app.route('/getUser', methods=['GET'])
    def getUser():
        try:
            cursor =conn.cursor()
            sql="select * from Users"
            cursor.execute(sql)
            results=[]
            keys=[]
            for i in cursor.description:
                keys.append(i[0])
            for val in cursor.fetchall():
                results.append(dict(zip(keys,val)))        
            repr = flask.jsonify(results)
            repr.status_code=200
            return repr
        except:
            print("Lỗi")

            
    @app.route('/getField', methods=['GET'])
    def getField():
        try:
            placeid = request.args.get('placeid')  # Lấy placeid từ tham số truy vấn
            if not placeid:
                return "placeid là bắt buộc", 400

            cursor = conn.cursor()
            sql = "exec getFieldById @PlaceId=?"
            val = (placeid,)
            cursor.execute(sql, val)
            
            results = []
            keys = [column[0] for column in cursor.description]

            for row in cursor.fetchall():
                results.append(dict(zip(keys, row)))
            
            return render_template('Field.html', data=results)
        except Exception as e:   
            print("Lỗi:", e)
            return "Đã xảy ra lỗi", 500


    @app.route('/getPlace', methods=['GET'])
    def getPlace():
        try:
                cursor = conn.cursor()
                sql = "exec getPlace"
                cursor.execute(sql)
                results = []
                keys = []
                for i in cursor.description:
                    keys.append(i[0])
                for val in cursor.fetchall():
                    results.append(dict(zip(keys, val)))
                return render_template('index.html', data=results)
        except Exception as e:
                print("Lỗi:", e)
                return "Đã xảy ra lỗi", 500


  
        render_template('login.html',method=['GET'])   
   
   
    @app.route('/register', methods=['GET', 'POST'])
    def register():
     if request.method == 'POST':
        data = request.form
        username = data['username']
        email = data['email']
        password = data['password']
        phone_number = data['phone_number']
        full_name = data['full_name']

        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        try:
            cursor.execute("EXEC RegisterUser ?, ?, ?, ?, ?", (username, email, password, phone_number, full_name))
            conn.commit()
            cursor.close()
            conn.close()
            return jsonify({'message': 'Đăng ký người dùng thành công!'}), 201
        except pyodbc.Error as e:
            error_message = str(e)
            print("Lỗi SQL:", error_message)  # Ghi log lỗi SQL ra console
            return jsonify({'error': error_message}), 400

     return render_template('register.html')

   
    @app.route('/login', methods=['GET', 'POST'])
    def login():
     if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        try:
            cursor.execute("EXEC LoginUser ?, ?", (username, password))
            user = cursor.fetchone()

            if user:
                # Đăng nhập thành công
                # session['user_id'] = user[0]  # Lưu user_id vào session (nếu cần thiết)
                return jsonify({
                    'message': 'Đăng nhập thành công!',
                    'user': {
                        'UserID': user[0],
                        'Username': user[1],
                        'Email': user[2],
                        'PhoneNumber': user[3],
                        'FullName': user[4]
                    }
                }), 200
            else:
                # Đăng nhập thất bại
                return jsonify({'error': 'Tên đăng nhập hoặc mật khẩu không chính xác'}), 401

        except pyodbc.Error as e:
            error_message = str(e)
            print("Lỗi SQL:", error_message)  # Ghi log lỗi SQL ra console
            return jsonify({'error': error_message}), 500

     return render_template('login.html')
    
    
    
    if __name__ == "__main__":
        app.run(port=2323)    

except Exception as e:
    print("Lỗi:", e)