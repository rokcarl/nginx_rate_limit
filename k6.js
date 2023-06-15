import http from 'k6/http';
import { sleep } from 'k6';
import { check } from 'k6';


http.setResponseCallback(http.expectedStatuses({ min: 200, max: 299 }));

export const options = {
  vus: 5,
  duration: '10s',
};
export default function () {
  const res = http.get('http://localhost:8080/?key=a');
  check(
    res,
    {
      'response code was 200': (res) => res.status == 200,
    }
  );
  sleep(1);
}
