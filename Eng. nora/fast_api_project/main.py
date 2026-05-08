from fastapi import FastAPI

from routers import users, projects, tasks
from database import Base, engine

import models.user, models.project, models.task
from fastapi.middleware.cors import CORSMiddleware
Base.metadata.create_all(bind=engine)

app = FastAPI(title="FastAPI SQLAlchemy CRUD Example")
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,     
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(users.router)
app.include_router(projects.router)
app.include_router(tasks.router)
