#include "rwlock.h"

void InitalizeReadWriteLock(struct read_write_lock * rw)
{
  //	Write the code for initializing your read-write lock.
  rw = new read_write_lock;
  pthread_mutex_lock(&rw->mutex);
  rw->readers = 0;
  rw->writers = 0;
  pthread_mutex_unlock(&rw->mutex);
}

void ReaderLock(struct read_write_lock * rw)
{
  //	Write the code for aquiring read-write lock by the reader.
  pthread_mutex_lock(&rw->mutex);
  while (rw->writers>0)
    ;
  rw->readers++;
  pthread_mutex_unlock(&rw->mutex);
}

void ReaderUnlock(struct read_write_lock * rw)
{
  //	Write the code for releasing read-write lock by the reader.
  pthread_mutex_lock(&rw->mutex);
  rw->readers--;
  pthread_mutex_unlock(&rw->mutex);
}

void WriterLock(struct read_write_lock * rw)
{
  //	Write the code for aquiring read-write lock by the writer.
  pthread_mutex_lock(&rw->mutex);
  while (rw->readers>0)
    ;
  rw->writers++;
  pthread_mutex_unlock(&rw->mutex);
}

void WriterUnlock(struct read_write_lock * rw)
{
  //	Write the code for releasing read-write lock by the writer.
  pthread_mutex_lock(&rw->mutex);
  if (rw->writers > 0)
    rw->writers--;
  pthread_mutex_unlock(&rw->mutex);
}
