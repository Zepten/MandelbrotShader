#ifdef GL_ES
  precision mediump float;
#endif

uniform vec2 u_res;        // Input screen resolution vector
uniform vec2 u_translate;  // Input translate vector
uniform float u_zoom;      // Input zoom

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  double res = min(u_res.x, u_res.y); // Min resolution
  double cr = u_translate.x/res + (gl_FragCoord.x - u_res.x * 0.5) / (res * u_zoom); // Real component
  double ci = u_translate.y/res - (gl_FragCoord.y - u_res.y * 0.5) / (res * u_zoom); // Imaginary component
  dvec2 c = dvec2(cr, ci); // Complex translate number
  dvec2 z = c; // Complex number itself

  int i = 0;
  int maxiter = 40 + int(max(0.0, 2.0 * log(u_zoom))); // Maximum iteration count
  for (i = 0; i < maxiter; i++) {
    z = dvec2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c;
    if (z.x * z.x + z.y * z.y > 4.0) break;
  }
  
  vec3 color; // Final color
  if (i == maxiter) // If in set...
    color = vec3(0.0); // ...then black...
  else
    color = hsv2rgb(vec3(i / float(maxiter), 1.0, 1.0)); // ...else HSV color depending on last iteration
  gl_FragColor = vec4(color, 1.0);
}
