import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App {
  protected title = 'TestEnv';
  private testURL = import.meta.env['NG_APP_URL'];

  ngOnInit() {
    console.log(this.testURL);
  }
}
