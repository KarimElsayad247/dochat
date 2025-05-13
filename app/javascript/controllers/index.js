import { Application } from "@hotwired/stimulus";
import { registerControllers } from "stimulus-vite-helpers";
import { MarksmithController } from '@avo-hq/marksmith'

const application = Application.start();
const controllers = import.meta.glob("./**/*_controller.js", { eager: true });

registerControllers(application, controllers);
application.register('marksmith', MarksmithController)
