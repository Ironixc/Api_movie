import 'package:api_insert/models/response_data_list.dart';
import 'package:api_insert/models/movie_model.dart';
import 'package:api_insert/models/response_data_map.dart';
import 'package:api_insert/models/user_login.dart';
import 'package:api_insert/services/url.dart' as url;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:http_parser/http_parser.dart';

class MovieService {
  Future getMovie() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    var uri = Uri.parse(url.BaseUrl + "/admin/getmovie");
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
    };
    var getMovie = await http.get(uri, headers: headers);

    if (getMovie.statusCode == 200) {
      var data = json.decode(getMovie.body);
      if (data["status"] == true) {
        List movie = data["data"].map((r) => MovieModel.fromJson(r)).toList();
        ResponseDataList response = ResponseDataList(
            status: true, message: 'success load data', data: movie);
        return response;
      } else {
        ResponseDataList response =
            ResponseDataList(status: false, message: 'Failed load data');
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
          status: false,
          message: "gagal load movie dengan code error ${getMovie.statusCode}");
      return response;
    }
  }

  Future insertMovie(Map<String, dynamic> request, File? image,
      Uint8List? imageBytes, int? id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
          status: false, message: 'Anda belum login / token invalid');
    }

    var uri = id == null
        ? Uri.parse("${url.BaseUrl}/admin/insertmovie")
        : Uri.parse("${url.BaseUrl}/admin/updatemovie/$id");

    var requestUpload = http.MultipartRequest('POST', uri);
    requestUpload.headers["Authorization"] = 'Bearer ${user.token}';
    requestUpload.fields['title'] = request["title"];
    requestUpload.fields['voteaverage'] = request["voteaverage"];
    requestUpload.fields['overview'] = request["overview"];

    if (imageBytes != null) {
      // Untuk Web
      requestUpload.files.add(
        http.MultipartFile.fromBytes(
          'posterpath',
          imageBytes,
          filename: "upload.jpg",
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    } else if (image != null) {
      // Untuk Mobile & Desktop
      requestUpload.files.add(
        http.MultipartFile(
          'posterpath',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path.split('/').last,
        ),
      );
    }

    var response = await requestUpload.send();
    var result = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      var data = json.decode(result.body);
      return data["status"] == true
          ? ResponseDataMap(
              status: true, message: 'Success insert / update data')
          : ResponseDataMap(
              status: false, message: 'Failed insert / update data');
    } else {
      return ResponseDataMap(
          status: false,
          message:
              "Gagal upload movie dengan code error ${response.statusCode}");
    }
  }

  Future hapusMovie(context, id) async {
    UserLogin userLogin = UserLogin();

    var user = await userLogin.getUserLogin();
    var uri = Uri.parse(url.BaseUrl + "/admin/hapusmovie/$id");

    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Content-type": "multipart/form-data",
    };
    var hapusMovie = await http.delete(uri, headers: headers);
    if (hapusMovie.statusCode == 200) {
      var result = json.decode(hapusMovie.body);
      if (result["status"] == true) {
        ResponseDataList response =
            ResponseDataList(status: true, message: 'success hapus data');
        return response;
      } else {
        ResponseDataList response =
            ResponseDataList(status: false, message: 'Failed hapus data');
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
          status: false,
          message:
              "gagal hapus movie dengan code error ${hapusMovie.statusCode}");
      return response;
    }
  }

  Future getMovieUser() async {
    UserLogin userLogin = UserLogin();
    var uri = Uri.parse(url.BaseUrl + "/admin/getmovie/");
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
    };
    var getMovie = await http.get(uri, headers: headers);

    if (getMovie.statusCode == 200) {
      var data = json.decode(getMovie.body);
      if (data["status"] == true) {

        List movie = data["data"].map((r)=> MovieModel.fromJson(r)).toList();
        ResponseDataList response = ResponseDataList(
            status: true, message: 'success load data', data: movie);
        return response;
      } else {
        ResponseDataList response =
            ResponseDataList(status: false, message: 'Failed load data');
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
          status: false,
          message: "gagal load movie dengan code error ${getMovie.statusCode}");
      return response;
    }
  }
}
