function fn() {
  var config = {
    baseUrl: 'https://api.demoblaze.com',
    headers: {
      'Content-Type': 'application/json'
    }
  };

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);
  
  return config;
}

